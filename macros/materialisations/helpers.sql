{#-- Helper macros for custom materializations #}

{#-- MULTI-DISPATCH MACROS #}

{#-- REPLACE_PLACEHOLDER_WITH_FILTER #}

{%- macro replace_placeholder_with_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) -%}

    {% set macro = adapter.dispatch('replace_placeholder_with_filter',
                                    packages = ['dbtvault'])(core_sql=core_sql,
                                                             timestamp_field=timestamp_field,
                                                             start_timestamp=start_timestamp,
                                                             stop_timestamp=stop_timestamp,
                                                             offset=offset,
                                                             period=period) %}
    {% do return(macro) %}
{%- endmacro %}

{% macro snowflake__replace_placeholder_with_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) %}

    {%- set period_filter -%}
            (TO_DATE({{ timestamp_field }}) >= DATE_TRUNC('{{ period }}', TO_DATE('{{ start_timestamp }}') + INTERVAL '{{ offset }} {{ period }}') AND
             TO_DATE({{ timestamp_field }}) < DATE_TRUNC('{{ period }}', TO_DATE('{{ start_timestamp }}') + INTERVAL '{{ offset }} {{ period }}' + INTERVAL '1 {{ period }}'))
      AND (TO_DATE({{ timestamp_field }}) >= TO_DATE('{{ start_timestamp }}'))
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__PERIOD_FILTER__", period_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}


{#-- GET_PERIOD_FILTER_SQL #}

{%- macro get_period_filter_sql(target_cols_csv, base_sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

    {% set macro = adapter.dispatch('get_period_filter_sql',
                                    packages = ['dbtvault'])(target_cols_csv=target_cols_csv,
                                                             base_sql=base_sql,
                                                             timestamp_field=timestamp_field,
                                                             period=period,
                                                             start_timestamp=start_timestamp,
                                                             stop_timestamp=stop_timestamp,
                                                             offset=offset) %}
    {% do return(macro) %}
{%- endmacro %}

{% macro snowflake__get_period_filter_sql(target_cols_csv, base_sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

    {%- set filtered_sql = {'sql': base_sql} -%}

    {%- do filtered_sql.update({'sql': dbtvault.replace_placeholder_with_filter(filtered_sql.sql,
                                                                                timestamp_field,
                                                                                start_timestamp,
                                                                                stop_timestamp,
                                                                                offset, period)}) -%}
    select {{ target_cols_csv }} from ({{ filtered_sql.sql }})
{%- endmacro %}


{#-- GET_PERIOD_BOUNDARIES #}

{%- macro get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

    {% set macro = adapter.dispatch('get_period_boundaries',
                                    packages = ['dbtvault'])(target_schema=target_schema,
                                                             target_table=target_table,
                                                             timestamp_field=timestamp_field,
                                                             start_date=start_date,
                                                             stop_date=stop_date,
                                                             period=period) %}

    {% do return(macro) %}
{%- endmacro %}

{% macro snowflake__get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

    {% set period_boundary_sql -%}
        with data as (
            select
                coalesce(max({{ timestamp_field }}), '{{ start_date }}')::timestamp as start_timestamp,
                coalesce({{ dbt_utils.dateadd('millisecond', 86399999, "nullif('" ~ stop_date ~ "','')::timestamp") }},
                         {{ dbt_utils.current_timestamp() }} ) as stop_timestamp
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

    {% do return(period_boundaries) %}
{%- endmacro %}


{#-- GET_PERIOD_OF_LOAD #}

{%- macro get_period_of_load(period, offset, start_timestamp) -%}

    {% set macro = adapter.dispatch('get_period_of_load',
                                    packages = ['dbtvault'])(period=period,
                                                             offset=offset,
                                                             start_timestamp=start_timestamp) %}

    {% do return(macro) %}
{%- endmacro %}

{%- macro snowflake__get_period_of_load(period, offset, start_timestamp) -%}

    {% set period_of_load_sql -%}
        SELECT DATE_TRUNC('{{ period }}', DATEADD({{ period }}, {{ offset }}, TO_DATE('{{start_timestamp}}'))) AS period_of_load
    {%- endset %}

    {% set period_of_load_dict = dbt_utils.get_query_results_as_dict(period_of_load_sql) %}

    {% set period_of_load = period_of_load_dict['PERIOD_OF_LOAD'][0] | string %}

    {% do return(period_of_load) %}
{%- endmacro -%}


{#-- OTHER MACROS #}

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


{% macro check_placeholder(model_sql, placeholder='__PERIOD_FILTER__') %}

    {%- if model_sql.find(placeholder) == -1 -%}
        {%- set error_message -%}
            Model '{{ model.unique_id }}' does not include the required string '__PERIOD_FILTER__' in its sql
        {%- endset -%}
        {{ exceptions.raise_compiler_error(error_message) }}
    {%- endif -%}

{% endmacro %}


{% macro get_start_stop_dates(timestamp_field, date_source_models) %}

    {% if config.get('start_date', default=none) is not none %}

        {%- set start_date = config.get('start_date') -%}
        {%- set stop_date = config.get('stop_date', default=none) -%}

        {% do return({'start_date': start_date,'stop_date': stop_date}) %}

    {% elif date_source_models is not none %}

        {% if date_source_models is string %}
            {% set date_source_models = [date_source_models] %}
        {% endif %}
        {% set query_sql %}
            WITH stage AS (
            {% for source_model in date_source_models %}
                SELECT {{ timestamp_field }} FROM {{ ref(source_model) }}
                {% if not loop.last %} UNION ALL {% endif %}
            {% endfor %})

            SELECT MIN({{ timestamp_field }}) AS MIN, MAX({{ timestamp_field }}) AS MAX
            FROM stage
        {% endset %}

        {% set min_max_dict = dbt_utils.get_query_results_as_dict(query_sql) %}

        {% set start_date = min_max_dict['MIN'][0] | string %}
        {% set stop_date = min_max_dict['MAX'][0] | string %}
        {% set min_max_dates = {"start_date": start_date, "stop_date": stop_date} %}

        {% do return(min_max_dates) %}

    {% else %}
        {%- if execute -%}
            {{ exceptions.raise_compiler_error("Invalid 'vault_insert_by_period' configuration. Must provide 'start_date' and 'stop_date' and/or 'date_source_models' options.") }}
        {%- endif -%}
    {% endif %}

{% endmacro %}