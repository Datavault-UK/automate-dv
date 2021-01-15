{%- macro drop_model(model_name) -%}

    {%- set source_relation = adapter.get_relation(
          database=target.database,
          schema=target.schema,
          identifier=model_name) -%}

    {% if source_relation %}
        {%- do adapter.drop_relation(source_relation) -%}
        {% do log('Successfully dropped model ' ~ "'" ~ model_name ~ "'", true) %}
    {% else %}
        {% do log('Nothing to drop', true) %}
    {% endif %}

{%- endmacro -%}

{% macro check_model_exists(model_name) %}

    {% set schema_name %} 
        {{ target.schema }}_{{ env_var('SNOWFLAKE_DB_USER') }}{{ '_' ~ env_var('CIRCLE_BRANCH', '') if env_var('CIRCLE_BRANCH', '') }}{{ '_' ~ env_var('CIRCLE_JOB', '') if env_var('CIRCLE_JOB', '') }}{{ '_' ~ env_var('CIRCLE_NODE_INDEX', '') if env_var('CIRCLE_NODE_INDEX', '') }}
    {% endset %}

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

    {% set schema_name %} 
        {{ target.schema }}_{{ env_var('SNOWFLAKE_DB_USER') }}{{ '_' ~ env_var('CIRCLE_BRANCH', '') if env_var('CIRCLE_BRANCH', '') }}{{ '_' ~ env_var('CIRCLE_JOB', '') if env_var('CIRCLE_JOB', '') }}{{ '_' ~ env_var('CIRCLE_NODE_INDEX', '') if env_var('CIRCLE_NODE_INDEX', '') }}
    {% endset %}

    {% do adapter.drop_schema(api.Relation.create(database=target.database, schema=schema_name )) %}

{% endmacro %}

{%- macro create_test_schemas() -%}

    {% set schema_name %} 
        {{ target.schema }}_{{ env_var('SNOWFLAKE_DB_USER') }}{{ '_' ~ env_var('CIRCLE_BRANCH', '') if env_var('CIRCLE_BRANCH', '') }}{{ '_' ~ env_var('CIRCLE_JOB', '') if env_var('CIRCLE_JOB', '') }}{{ '_' ~ env_var('CIRCLE_NODE_INDEX', '') if env_var('CIRCLE_NODE_INDEX', '') }}
    {% endset %}

    {% do adapter.create_schema(api.Relation.create(database=target.database, schema=schema_name )) %}

{%- endmacro -%}

{%- macro recreate_current_schemas() -%}

{% do drop_test_schemas() %}
{% do create_test_schemas() %}

{%- endmacro -%}