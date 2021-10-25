{#-- Helper macros for period materializations #}

{#-- MULTI-DISPATCH MACROS #}

{#-- REPLACE_PLACEHOLDER_WITH_PERIOD_FILTER #}

{%- macro replace_placeholder_with_period_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) -%}

    {% set macro = adapter.dispatch('replace_placeholder_with_period_filter',
                                    'dbtvault')(core_sql=core_sql,
                                                timestamp_field=timestamp_field,
                                                start_timestamp=start_timestamp,
                                                stop_timestamp=stop_timestamp,
                                                offset=offset,
                                                period=period) %}
    {% do return(macro) %}
{%- endmacro %}

{% macro default__replace_placeholder_with_period_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) %}

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
                                    'dbtvault')(target_cols_csv=target_cols_csv,
                                                base_sql=base_sql,
                                                timestamp_field=timestamp_field,
                                                period=period,
                                                start_timestamp=start_timestamp,
                                                stop_timestamp=stop_timestamp,
                                                offset=offset) %}
    {% do return(macro) %}
{%- endmacro %}

{% macro default__get_period_filter_sql(target_cols_csv, base_sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

    {%- set filtered_sql = {'sql': base_sql} -%}

    {%- do filtered_sql.update({'sql': dbtvault.replace_placeholder_with_period_filter(filtered_sql.sql,
                                                                                       timestamp_field,
                                                                                       start_timestamp,
                                                                                       stop_timestamp,
                                                                                       offset, period)}) -%}
    select {{ target_cols_csv }} from ({{ filtered_sql.sql }})
{%- endmacro %}

{#-- GET_PERIOD_BOUNDARIES #}

{%- macro get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

    {% set macro = adapter.dispatch('get_period_boundaries',
                                    'dbtvault')(target_schema=target_schema,
                                                target_table=target_table,
                                                timestamp_field=timestamp_field,
                                                start_date=start_date,
                                                stop_date=stop_date,
                                                period=period) %}

    {% do return(macro) %}
{%- endmacro %}



{% macro default__get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

    {% set period_boundary_sql -%}
        WITH period_data AS (
            SELECT
                COALESCE(MAX({{ timestamp_field }}), '{{ start_date }}')::TIMESTAMP AS start_timestamp,
                COALESCE({{ dbt_utils.dateadd('millisecond', 86399999, "NULLIF('" ~ stop_date | lower ~ "','none')::TIMESTAMP") }},
                         {{ dbtvault.current_timestamp() }} ) AS stop_timestamp
            FROM {{ target_schema }}.{{ target_table }}
        )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ dbt_utils.datediff('start_timestamp',
                                  'stop_timestamp',
                                  period) }} + 1 AS num_periods
        FROM period_data
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
                                    'dbtvault')(period=period,
                                                offset=offset,
                                                start_timestamp=start_timestamp) %}

    {% do return(macro) %}
{%- endmacro %}


{%- macro default__get_period_of_load(period, offset, start_timestamp) -%}

    {% set period_of_load_sql -%}
        SELECT DATE_TRUNC('{{ period }}', DATEADD({{ period }}, {{ offset }}, TO_DATE('{{ start_timestamp }}'))) AS period_of_load
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
            {{ exceptions.raise_compiler_error("Invalid 'vault_insert_by_period' configuration. Must provide 'start_date' and 'stop_date', just 'stop_date', and/or 'date_source_models' options.") }}
        {%- endif -%}
    {% endif %}

{% endmacro %}