{% macro get_query_results_as_dict(query) %}
    {{ return(adapter.dispatch('get_query_results_as_dict', 'dbtvault')(query)) }}
{% endmacro %}

{% macro default__get_query_results_as_dict(query) %}
    {{ return(dbt_utils.get_query_results_as_dict(query)) }}
{% endmacro %}

{% macro sqlserver__get_query_results_as_dict(query) %}

    {%- call statement('get_query_results', fetch_result=True,auto_begin=false) -%}

        {{ query }}

    {%- endcall -%}

    {% set sql_results={} %}

    {%- if execute -%}
        {% set sql_results_table = load_result('get_query_results').table.columns %}
        {% for column_name, column in sql_results_table.items() %}
            {# Column names in upper case for consistency #}
            {% do sql_results.update({column_name.upper(): column.values()}) %}
        {% endfor %}
    {%- endif -%}

    {{ return(sql_results) }}

{% endmacro %}

{#- [ ] TODO TEMPORARY solution is to call the SQLSERVER implementation which will UPPERCASE the column names -#}
{% macro postgres__get_query_results_as_dict(query) %}
{% do log('🐘🐘🐘calling get_query_results_as_dict: TEMPORARY fix is to call the SQLServer implementation.') %}
    {{ return(dbtvault.sqlserver__get_query_results_as_dict(query)) }}
{% endmacro %}
