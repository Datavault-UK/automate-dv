{%- macro replace_placeholder_with_rank_filter(core_sql, rank_column, rank_iteration) -%}

    {% set macro = adapter.dispatch('replace_placeholder_with_rank_filter',
                                    'dbtvault')(core_sql=core_sql,
                                                rank_column=rank_column,
                                                rank_iteration=rank_iteration) %}
    {% do return(macro) %}
    {%- endmacro %}

    {% macro default__replace_placeholder_with_rank_filter(core_sql, rank_column, rank_iteration) %}

    {%- set rank_filter -%}
    {{ rank_column }}:: INTEGER = {{ rank_iteration }}::INTEGER
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__RANK_FILTER__", rank_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}




{% macro sqlserver__replace_placeholder_with_rank_filter(core_sql, rank_column, rank_iteration) %}

    {%- set rank_filter -%}
        CAST({{ rank_column }} AS INT) = CAST({{ rank_iteration }} AS INT)
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__RANK_FILTER__", rank_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}




{% macro bigquery__replace_placeholder_with_rank_filter(core_sql, rank_column, rank_iteration) %}
    {%- set rank_filter -%}
        CAST({{ rank_column }} AS INTEGER) = CAST({{ rank_iteration }} AS INTEGER)
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__RANK_FILTER__", rank_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}