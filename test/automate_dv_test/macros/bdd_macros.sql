/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro drop_model(model_name) -%}

    {% set schema_name = automate_dv_test.get_schema_name() %}

    {%- if target.type == 'databricks' -%}
        {%- set source_relation = adapter.get_relation(
              schema=schema_name,
              identifier=model_name) -%}

    {%- else -%}
        {%- set source_relation = adapter.get_relation(
              database=target.database,
              schema=schema_name,
              identifier=model_name) -%}
    {%- endif -%}

    {% if source_relation %}
        {%- do adapter.drop_relation(source_relation) -%}
        {% do log("Successfully dropped model '{}'".format(model_name), true) %}
    {% else %}
        {% do log('Nothing to drop', true) %}
    {% endif %}

{%- endmacro -%}

{% macro check_model_exists(model_name, drop_table=True) %}

    {% set schema_name = automate_dv_test.get_schema_name() %}

    {%- if target.type == 'databricks' -%}
        {%- set source_relation = adapter.get_relation(
              database=schema_name,
              schema=schema_name,
              identifier=model_name) -%}
    {%- else -%}
        {%- set source_relation = adapter.get_relation(
              database=target.database,
              schema=schema_name,
              identifier=model_name) -%}
    {%- endif -%}

    {% if source_relation %}
        {%- if drop_table -%}
            {%- set query -%}
                DROP TABLE {{ source_relation }}
            {%- endset -%}
            {%- do run_query(query) -%}
        {%- else -%}
            {% do log('Model {} exists.'.format(model_name), true) %}
        {%- endif -%}
    {% else %}
        {% do log('Model {} does not exist.'.format(model_name), true) %}
    {% endif %}

{% endmacro %}

{% macro drop_all_custom_schemas(schema_prefix=none) %}

    {%- if not schema_prefix -%}
        {% set schema_name = automate_dv_test.get_schema_name() -%}
    {%- else -%}
        {% set schema_name = schema_prefix -%}
    {%- endif -%}

    {%- if target.type == "snowflake" -%}
        {%- set list_custom_schemas_sql -%}
        SELECT SCHEMA_NAME FROM {{ target.database }}."INFORMATION_SCHEMA"."SCHEMATA"
        WHERE SCHEMA_NAME LIKE '{{ schema_name }}%'
        {%- endset -%}
    {%- endif -%}

    {%- if target.type == "bigquery" -%}
        {%- set list_custom_schemas_sql -%}
        SELECT SCHEMA_NAME FROM {{ target.database }}.INFORMATION_SCHEMA.SCHEMATA
        WHERE SCHEMA_NAME LIKE '{{ schema_name }}%'
        {%- endset -%}
    {%- endif -%}

    {%- if target.type == "databricks" -%}
        {%- set list_custom_schemas_sql -%}
        SHOW SCHEMAS
        {%- endset -%}
    {%- endif -%}

    {%- set custom_schema_list = dbt_utils.get_query_results_as_dict(list_custom_schemas_sql) -%}

    {%- if target.type == "databricks" -%}
        {%- for custom_schema_name in custom_schema_list['databaseName'] | reject("equalto", "default") | list -%}
            {%- do adapter.drop_schema(api.Relation.create(database=target.database, schema=custom_schema_name)) -%}
            {%- do log("Schema '{}' dropped.".format(custom_schema_name), true) -%}
        {%- endfor -%}
    {% else %}
        {%- for custom_schema_name in custom_schema_list['SCHEMA_NAME'] -%}
            {%- do adapter.drop_schema(api.Relation.create(database=target.database, schema=custom_schema_name)) -%}
            {%- do log("Schema '{}' dropped.".format(custom_schema_name), true) -%}
        {%- endfor -%}
    {%- endif -%}

{% endmacro %}

{%- macro drop_test_schemas() -%}

    {% set schema_name = automate_dv_test.get_schema_name() %}

    {%- if target.type == 'databricks' -%}
        {% do adapter.drop_schema(api.Relation.create(schema=schema_name)) %}
    {%- else -%}
        {% do adapter.drop_schema(api.Relation.create(database=target.database, schema=schema_name)) %}
    {%- endif -%}

    {% do log("Schema '{}' dropped.".format(schema_name), true) %}

{% endmacro %}


{%- macro drop_selected_schema(schema_to_drop) -%}

    {%- if target.type == 'databricks' -%}
        {% do adapter.drop_schema(api.Relation.create(schema=schema_to_drop)) %}
    {%- else -%}
        {% do adapter.drop_schema(api.Relation.create(database=target.database, schema=schema_to_drop)) %}
    {%- endif -%}

    {% do log("Schema '{}' dropped.".format(schema_to_drop), true) %}

{% endmacro %}

{%- macro drop_current_schema() -%}

    {% set schema_to_drop = automate_dv_test.get_schema_name() %}

    {%- if target.type == 'databricks' -%}
        {% do adapter.drop_schema(api.Relation.create(schema=schema_to_drop)) %}
    {%- else -%}
        {% do adapter.drop_schema(api.Relation.create(database=target.database, schema=schema_to_drop)) %}
    {%- endif -%}

    {% do log("Schema '{}' dropped.".format(schema_to_drop), true) %}

{% endmacro %}


{%- macro create_test_schemas() -%}

    {% set schema_name = automate_dv_test.get_schema_name() %}

    {%- if target.type == 'databricks' -%}
        {% do adapter.create_schema(api.Relation.create(schema=schema_name)) %}
    {%- else -%}
        {% do adapter.create_schema(api.Relation.create(database=target.database, schema=schema_name)) %}
    {%- endif -%}

    {% do log("Schema '{}' created.".format(schema_name), true) %}

{%- endmacro -%}

{%- macro recreate_current_schemas() -%}

    {% do drop_test_schemas() %}
    {% do create_test_schemas() %}

{%- endmacro -%}
