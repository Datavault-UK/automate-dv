{%- macro drop_model(model_name) -%}

    {%- set source_relation = adapter.get_relation(
          database=target.database,
          schema=target.schema,
          identifier=model_name) -%}

    {% if source_relation %}
        {%- do adapter.drop_relation(source_relation) -%}
        {% do log("Successfully dropped model '{}'".format(model_name), true) %}
    {% else %}
        {% do log('Nothing to drop', true) %}
    {% endif %}

{%- endmacro -%}

{% macro check_model_exists(model_name) %}

    {% set schema_name = dbtvault_test.get_schema_name() %}

    {%- set source_relation = adapter.get_relation(
          database=target.database,
          schema=schema_name,
          identifier=model_name) -%}

    {% if source_relation %}
        {% do log('Model {} exists.'.format(model_name), true) %}
    {% else %}
        {% do log('Model {} does not exist.'.format(model_name), true) %}
    {% endif %}

{% endmacro %}

{% macro drop_all_custom_schemas(schema_prefix=none) %}

    {% if not schema_prefix %}
        {% set schema_name = dbtvault_test.get_schema_name() %}
    {% else %}
        {% set schema_name = schema_prefix %}
    {% endif %}

    {% set list_custom_schemas_sql %}
    SELECT SCHEMA_NAME FROM {{ target.database }}."INFORMATION_SCHEMA"."SCHEMATA"
    WHERE SCHEMA_NAME LIKE '{{ schema_name }}%'
    {% endset %}

    {% set custom_schema_list = dbt_utils.get_query_results_as_dict(list_custom_schemas_sql) %}

    {% for custom_schema_name in custom_schema_list['SCHEMA_NAME'] %}
        {% do adapter.drop_schema(api.Relation.create(database=target.database, schema=custom_schema_name)) %}
        {% do log("Schema '{}' dropped.".format(custom_schema_name), true) %}
    {% endfor %}

{% endmacro %}

{%- macro drop_test_schemas() -%}

    {% set schema_name = dbtvault_test.get_schema_name() %}

    {% do adapter.drop_schema(api.Relation.create(database=target.database, schema=schema_name)) %}
    {% do log("Schema '{}' dropped.".format(schema_name), true) %}

{% endmacro %}

{%- macro create_test_schemas() -%}

    {% set schema_name = dbtvault_test.get_schema_name() %}

    {% do adapter.create_schema(api.Relation.create(database=target.database, schema=schema_name)) %}
    {% do log("Schema '{}' created.".format(schema_name), true) %}

{%- endmacro -%}

{%- macro recreate_current_schemas() -%}

    {% do drop_test_schemas() %}
    {% do create_test_schemas() %}

{%- endmacro -%}