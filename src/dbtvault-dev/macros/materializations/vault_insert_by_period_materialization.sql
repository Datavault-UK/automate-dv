{% macro is_vault_insert_by_period() %}
    {#-- do not run introspective queries in parsing #}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

        {{ return(relation is not none
                  and relation.type == 'table'
                  and model.config.materialized == 'vault_insert_by_period'
                  and not flags.FULL_REFRESH) }}
    {% endif %}
{% endmacro %}

{% macro get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

    {% set period_boundary_sql -%}
        with data as (
            select
                coalesce(max({{ timestamp_field }}), '{{ start_date }}')::timestamp as start_timestamp,
                coalesce(
                {{ dbt_utils.dateadd('millisecond',
                                     86399999,
                                     "nullif('" ~ stop_date ~ "','')::timestamp")}},
                {{ dbt_utils.current_timestamp() }}
                ) as stop_timestamp
            from {{ target_schema }}.{{ target_table }}
        )
        select
            start_timestamp,
            stop_timestamp,
            {{ dbt_utils.datediff('start_timestamp',
                                  'stop_timestamp',
                                  period) }} + 1 as num_periods
        from data
    {%- endset %}

    {% set period_boundaries_dict = dbt_utils.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {{ return(period_boundaries) }}

{%- endmacro %}

{%- macro get_period_of_load(period, offset, start_timestamp) -%}

    {% set period_of_load_sql -%}
        SELECT DATE_TRUNC('{{ period }}', DATEADD({{ period }}, {{ offset }}, TO_DATE('{{start_timestamp}}'))) AS period_of_load
    {%- endset %}

    {% set period_of_load_dict = dbt_utils.get_query_results_as_dict(period_of_load_sql) %}

    {% set period_of_load = {'period_of_load': period_of_load_dict['PERIOD_OF_LOAD'][0] | string} %}

    {{ return(period_of_load.period_of_load) }}

{%- endmacro -%}

{% macro replace_filter_placeholder(sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) %}

    {%- set period_filter -%}
            (TO_DATE({{ timestamp_field }}) >= DATE_TRUNC('{{ period }}', TO_DATE('{{ start_timestamp }}') + INTERVAL '{{ offset }} {{ period }}') AND
             TO_DATE({{ timestamp_field }}) < DATE_TRUNC('{{ period }}', TO_DATE('{{ start_timestamp }}') + INTERVAL '{{ offset }} {{ period }}' + INTERVAL '1 {{ period }}'))
      AND (TO_DATE({{ timestamp_field }}) >= TO_DATE('{{ start_timestamp }}'))
    {%- endset -%}

    {%- set filtered_sql = sql | replace("__PERIOD_FILTER__", period_filter, 1) -%}

    {{ return(filtered_sql) }}

{% endmacro %}

{% macro get_period_filter_sql(target_cols_csv, sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

    {%- set filtered_sql = {'sql': sql} %}


    {% do filtered_sql.update({'sql': dbtvault.replace_filter_placeholder(filtered_sql.sql,
                                                                          timestamp_field,
                                                                          start_timestamp,
                                                                          stop_timestamp,
                                                                          offset, period)}) %}

    select
        {{target_cols_csv}}
    from (
        {{filtered_sql.sql}}
    )

{%- endmacro %}

{%- macro min_max_date(timestamp_field) %}

{%- set filtered_sql = sql | replace("__PERIOD_FILTER__", "1=1", 1) -%}

{% set query_sql %}
WITH source AS (
    {{ filtered_sql }}
)

SELECT MIN({{ timestamp_field }}) AS MIN, MAX({{ timestamp_field }}) AS MAX FROM source
{% endset %}

{% set min_max_dict = dbt_utils.get_query_results_as_dict(query_sql) %}

{% set min_max_dict = {'min': min_max_dict['MIN'][0] | string,
                       'max': min_max_dict['MAX'][0] | string} %}


{{ return(min_max_dict) }}

{%- endmacro -%}

{% materialization vault_insert_by_period, default -%}

    {% set full_refresh_mode = flags.FULL_REFRESH %}

    {%- set timestamp_field = config.require('timestamp_field') -%}
    {%- set min_max_date = dbtvault.min_max_date(timestamp_field) -%}
    {%- set start_date = config.get('start_date', default=min_max_date['min']) -%}
    {%- set stop_date = config.get('stop_date', default=min_max_date['max']) -%}
    {%- set period = config.get('period', default='day') -%}

    {% set target_relation = this %}
    {% set existing_relation = load_relation(this) %}
    {% set tmp_relation = make_temp_relation(this) %}

    {% set identifier = model['name'] %}

    {%- if sql.find('__PERIOD_FILTER__') == -1 -%}
        {%- set error_message -%}
            Model '{{ model.unique_id }}' does not include the required string '__PERIOD_FILTER__' in its sql
        {%- endset -%}
        {{ exceptions.raise_compiler_error(error_message) }}
    {%- endif -%}

    {{ run_hooks(pre_hooks, inside_transaction=False) }}

    -- `BEGIN` happens here:
    {{ run_hooks(pre_hooks, inside_transaction=True) }}

    {% set to_drop = [] %}
    {% if existing_relation is none %}

        {% set build_sql = create_table_as(False, target_relation, sql) %}

        {%- set filtered_sql = dbtvault.replace_filter_placeholder(build_sql, timestamp_field, start_date, stop_date, 0, period) %}

        {% call statement("main") %}
            {{ filtered_sql }}
        {% endcall %}

        {%- set msg -%}
            [BASE LOAD] Loaded {{ period }} 1 for {{ identifier }}
        {%- endset -%}

        {{ dbt_utils.log_info(msg) }}

    {% elif existing_relation.is_view or full_refresh_mode %}

        {#-- Make sure the backup doesn't exist so we don't encounter issues with the rename below #}
        {% set backup_identifier = existing_relation.identifier ~ "__dbt_backup" %}
        {% set backup_relation = existing_relation.incorporate(path={"identifier": backup_identifier}) %}
        {% do adapter.drop_relation(backup_relation) %}

        {% do adapter.rename_relation(target_relation, backup_relation) %}
        {% set build_sql = create_table_as(False, target_relation, sql) %}
        {% do to_drop.append(backup_relation) %}

        {% for rel in to_drop %}
            {% do adapter.drop_relation(rel) %}
        {% endfor %}

        {% call noop_statement(name='main', status='FULL-REFRESH') -%}
            -- no-op
        {%- endcall %}

        {{ return({'relations': [target_relation]}) }}

    {% else %}

        {% set period_boundaries = dbtvault.get_period_boundaries(schema,
                                                                  identifier,
                                                                  timestamp_field,
                                                                  start_date,
                                                                  stop_date,
                                                                  period) %}

        {% set target_columns = adapter.get_columns_in_relation(target_relation) %}
        {%- set target_cols_csv = target_columns | map(attribute='quoted') | join(', ') -%}
        {%- set loop_vars = {'sum_rows_inserted': 0} -%}

        -- commit each period as a separate transaction
        {% for i in range(period_boundaries.num_periods) -%}

            {%- set period_of_load = dbtvault.get_period_of_load(period, i, period_boundaries.start_timestamp) -%}

            {%- set msg = "Running for " ~ period ~ " " ~ (i + 1) ~ " of " ~ (period_boundaries.num_periods) ~ " (" ~ period_of_load ~ ") [" ~ model.unique_id ~ "]" -%}
            {{ dbt_utils.log_info(msg) }}

            {%- set tmp_identifier = model['name'] ~ '__dbt_incremental_period' ~ i ~ '_tmp' -%}
            {%- set tmp_relation = api.Relation.create(identifier=tmp_identifier,
                                                       schema=schema, type='table') -%}

            {% call statement() -%}
                {% set tmp_table_sql = dbtvault.get_period_filter_sql(target_cols_csv,
                                                                      sql,
                                                                      timestamp_field,
                                                                      period,
                                                                      period_boundaries.start_timestamp,
                                                                      period_boundaries.stop_timestamp,
                                                                      i) %}

                {{dbt.create_table_as(True, tmp_relation, tmp_table_sql)}}
            {%- endcall %}

            {{adapter.expand_target_column_types(from_relation=tmp_relation,
                                                 to_relation=target_relation)}}

            {%- set name = 'main-' ~ i -%}

            {% call statement(name, fetch_result=True) -%}
                insert into {{ target_relation }} ({{ target_cols_csv }})
                (
                  select
                      {{target_cols_csv}}
                  from {{tmp_relation.include(schema=False)}}
                );
            {%- endcall %}

            {%- set rows_inserted = (load_result('main-' ~ i)['status'].split(" "))[1] | int -%}

            {%- set sum_rows_inserted = loop_vars['sum_rows_inserted'] + rows_inserted -%}
            {%- if loop_vars.update({'sum_rows_inserted': sum_rows_inserted}) %} {% endif -%}

            {%- set msg = "Ran for " ~ period ~ " " ~ (i + 1) ~ " of " ~ (period_boundaries.num_periods) ~ "; " ~ rows_inserted ~ " records inserted [" ~ model.unique_id ~ "]" -%}
            {{ dbt_utils.log_info(msg) }}

            {% call statement() -%}
                begin;
            {%- endcall %}

        {%- endfor %}

    {% endif %}

    {{ run_hooks(post_hooks, inside_transaction=True) }}

    -- `COMMIT` happens here
    {% do adapter.commit() %}

    {% for rel in to_drop %}
        {{ drop_relation_if_exists(backup_relation) }}
    {% endfor %}

    {{ run_hooks(post_hooks, inside_transaction=False) }}

    {% if existing_relation and not full_refresh_mode -%}
        {%- set status_string = "INSERT " ~ loop_vars['sum_rows_inserted'] -%}

        {% call noop_statement(name='main', status=status_string) -%}
            -- no-op
        {%- endcall %}

    {% endif %}

    {{ return({'relations': [target_relation]}) }}

{%- endmaterialization %}