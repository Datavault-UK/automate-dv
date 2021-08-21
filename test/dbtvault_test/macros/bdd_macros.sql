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