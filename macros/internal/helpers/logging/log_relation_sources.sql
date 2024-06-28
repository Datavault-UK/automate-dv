/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro log_relation_sources(relation, source_count) %}
    {{ return(adapter.dispatch('log_relation_sources', 'automate_dv')(relation=relation, source_count=source_count)) }}
{%- endmacro -%}

{% macro default__log_relation_sources(relation, source_count) %}

    {%- if execute and automate_dv.is_something(invocation_args_dict.get('which')) and invocation_args_dict.get('which') != 'docs' -%}

        {%- do dbt_utils.log_info('Loading {} from {} source(s)'.format("{}.{}.{}".format(relation.database, relation.schema, relation.identifier),
                                                                        source_count)) -%}
    {%- endif -%}
{% endmacro %}

{% macro databricks__log_relation_sources(relation, source_count) %}

    {%- if execute and automate_dv.is_something(invocation_args_dict.get('which')) and invocation_args_dict.get('which') != 'docs' -%}

        {%- do dbt_utils.log_info('Loading {} from {} source(s)'.format("{}.{}".format(relation.schema, relation.identifier),
                                                                        source_count)) -%}
    {%- endif -%}
{% endmacro %}