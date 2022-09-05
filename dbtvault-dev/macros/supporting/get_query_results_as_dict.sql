{% macro get_query_results_as_dict(query) %}
    {{ return(adapter.dispatch('get_query_results_as_dict', 'dbtvault')(query)) }}
{% endmacro %}

{% macro default__get_query_results_as_dict(query) %}
    {%- set query_results = dbt_utils.get_query_results_as_dict(query) -%}
    {%- set query_results_processed = {} -%}

    {% for k, v in query_results.items() %}
        {% do query_results_processed.update({k.upper(): v}) %}
    {% endfor %}

    {{ return(query_results_processed) }}
{% endmacro %}

{#- [ ] TODO TEMPORARY solution is to call the SQLSERVER implementation which will UPPERCASE the column names -#}
{% macro postgres__get_query_results_as_dict(query) %}
{% do log('🐘🐘🐘calling get_query_results_as_dict: TEMPORARY fix is to call the SQLServer implementation.') %}
    {{ return(dbtvault.sqlserver__get_query_results_as_dict(query)) }}
{% endmacro %}
