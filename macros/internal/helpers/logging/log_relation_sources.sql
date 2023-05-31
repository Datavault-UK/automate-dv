/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro log_relation_sources(relation, source_count) %}
    {{ return(adapter.dispatch('log_relation_sources', 'automate_dv')(relation=relation, source_count=source_count)) }}
{%- endmacro -%}

{% macro default__log_relation_sources(relation, source_count) %}

    {%- if 'docs' not in invocation_args_dict['rpc_method'] and execute -%}

        {%- do dbt_utils.log_info('Loading {} from {} source(s)'.format("{}.{}.{}".format(relation.database, relation.schema, relation.identifier),
                                                                        source_count)) -%}
    {%- endif -%}
{% endmacro %}

{% macro databricks__log_relation_sources(relation, source_count) %}

    {%- if 'docs' not in invocation_args_dict['rpc_method'] and execute -%}

        {%- do dbt_utils.log_info('Loading {} from {} source(s)'.format("{}.{}".format(relation.schema, relation.identifier),
                                                                        source_count)) -%}
    {%- endif -%}
{% endmacro %}