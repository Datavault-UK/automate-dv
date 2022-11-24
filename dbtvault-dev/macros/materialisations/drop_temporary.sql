{% macro drop_temporary_special(tmp_relation) %}
    {# In databricks and sqlserver a temporary view/table can only be dropped by #}
    {# the connection or session that created it so drop it now before the commit below closes this session #}

    {%- set drop_query_name = 'DROP_QUERY-' ~ i -%}
    {% call statement(drop_query_name, fetch_result=True) -%}
        {% if target.type == 'databricks' %}
            DROP VIEW {{ tmp_relation }};
        {% elif target.type == 'sqlserver' %}
            DROP TABLE {{ tmp_relation }};
        {% endif %}
    {%- endcall %}

{% endmacro %}