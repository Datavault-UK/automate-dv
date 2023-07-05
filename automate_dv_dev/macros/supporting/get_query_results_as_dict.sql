/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro get_query_results_as_dict(query) %}
    {{ return(adapter.dispatch('get_query_results_as_dict', 'automate_dv')(query)) }}
{% endmacro %}

{% macro default__get_query_results_as_dict(query) %}
    {%- set query_results = dbt_utils.get_query_results_as_dict(query) -%}
    {%- set query_results_processed = {} -%}

    {% for k, v in query_results.items() %}
        {% do query_results_processed.update({k.upper(): v}) %}
    {% endfor %}

    {{ return(query_results_processed) }}
{% endmacro %}
