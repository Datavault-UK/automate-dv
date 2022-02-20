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




{% macro sqlserver__get_period_filter_sql(target_cols_csv, base_sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

    {%- set filtered_sql = {'sql': base_sql} -%}

    {%- do filtered_sql.update({'sql': dbtvault.replace_placeholder_with_period_filter(filtered_sql.sql,
                                                                                       timestamp_field,
                                                                                       start_timestamp,
                                                                                       stop_timestamp,
                                                                                       offset, period)}) -%}
    {# MSSQL does not allow CTEs in a subquery #}
    {{ filtered_sql.sql }}
{%- endmacro %}