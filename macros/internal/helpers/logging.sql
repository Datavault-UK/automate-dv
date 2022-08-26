{% macro log_relation_sources(relation, source_count) %}
    {{ return(adapter.dispatch('log_relation_sources', 'dbtvault')(relation=relation, source_count=source_count)) }}
{%- endmacro -%}

{% macro default__log_relation_sources(relation, source_count) %}

    {%- if execute -%}

        {%- do dbt_utils.log_info('Loading {} from {} source(s)'.format("{}.{}.{}".format(relation.database, relation.schema, relation.identifier),
                                                                        source_count)) -%}
    {%- endif -%}
{% endmacro %}

{% macro databricks__log_relation_sources(relation, source_count) %}

    {%- if execute -%}

        {%- do dbt_utils.log_info('Loading {} from {} source(s)'.format("{}.{}".format(relation.schema, relation.identifier),
                                                                        source_count)) -%}
    {%- endif -%}
{% endmacro %}