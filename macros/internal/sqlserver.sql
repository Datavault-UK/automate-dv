# Overrides for dbt-sqlserver adapter functionality

{# TODO multi dispatch not working for the following macro using the new method in dbt v0.20.0 #}
{# TODO dbt-sqlserver adapters.sql revised with the macro code below #}
{# TODO leaving the macro code below not commented out for the time being #}
{% macro sqlserver__create_table_as(temporary, relation, sql) -%}
   {%- set as_columnstore = config.get('as_columnstore', default=true) -%}
   {% set tmp_relation = relation.incorporate(
   path={"identifier": relation.identifier.replace("#", "") ~ '_temp_view'},
   type='view') -%}
   {%- set temp_view_sql = sql.replace("'", "''") -%}

   {# Assign default relation.type if None #}
   {% if relation.type == None -%}
      {% set relation = relation.incorporate(type='table') -%}
   {% endif -%}

   {{ sqlserver__drop_relation_script(tmp_relation) }}

   {{ sqlserver__drop_relation_script(relation) }}

   USE [{{ relation.database }}];
   EXEC('create view {{ tmp_relation.include(database=False) }} as
    {{ temp_view_sql }}
    ');

   SELECT * INTO {{ relation }} FROM
    {{ tmp_relation }}

   {{ sqlserver__drop_relation_script(tmp_relation) }}

   {% if not temporary and as_columnstore -%}
   {{ sqlserver__create_clustered_columnstore_index(relation) }}
   {% endif %}

{% endmacro %}

{# TODO multi dispatch not working for the following macro using the new method in dbt v0.20.0 #}
{# TODO the full materialization code with sqlserver customisation below is working OK #}
{#{% macro sqlserver__get_test_sql(main_sql, fail_calc, warn_if, error_if, limit) -%}#}
{##}
{#    SELECT {{ "TOP (" ~ limit ~ ")" if limit != none }}#}
{#      {{ fail_calc }} AS failures,#}
{#      CAST(CASE WHEN {{ fail_calc}} {{ warn_if}} THEN 1 ELSE 0 END AS bit) AS should_warn,#}
{#      CAST(CASE WHEN {{ fail_calc}} {{ warn_if}} THEN 1 ELSE 0 END AS bit) AS should_error#}
{#    FROM (#}
{#      {{ main_sql }}#}
{#    ) AS dbt_internal_test#}
{##}
{#{%- endmacro %}#}

{%- materialization test, adapter='sqlserver' -%}

  {% set relations = [] %}

  {% if should_store_failures() %}

    {% set identifier = model['alias'] %}
    {% set old_relation = adapter.get_relation(database=database, schema=schema, identifier=identifier) %}
    {% set target_relation = api.Relation.create(
        identifier=identifier, schema=schema, database=database, type='table') -%} %}

    {% if old_relation %}
        {% do adapter.drop_relation(old_relation) %}
    {% endif %}

    {% call statement(auto_begin=True) %}
        {{ create_table_as(False, target_relation, sql) }}
    {% endcall %}

    {% do relations.append(target_relation) %}

    {% set main_sql %}
        SELECT *
        FROM {{ target_relation }}
    {% endset %}

    {{ adapter.commit() }}

  {% else %}

      {% set main_sql = sql %}

  {% endif %}

  {% set limit = config.get('limit') %}
  {% set fail_calc = config.get('fail_calc') %}
  {% set warn_if = config.get('warn_if') %}
  {% set error_if = config.get('error_if') %}

  {% call statement('main', fetch_result=True) -%}

{# TODO multi dispatch not working for the following macro using the new method in dbt v0.20.0 #}
{#    {{ get_test_sql(main_sql, fail_calc, warn_if, error_if, limit) }}#}

    SELECT {{ "TOP (" ~ limit ~ ")" if limit != none }}
      {{ fail_calc }} AS failures,
      CAST(CASE WHEN {{ fail_calc}} {{ warn_if}} THEN 1 ELSE 0 END AS bit) AS should_warn,
      CAST(CASE WHEN {{ fail_calc}} {{ warn_if}} THEN 1 ELSE 0 END AS bit) AS should_error
    FROM (
      {{ main_sql }}
    ) AS dbt_internal_test

  {%- endcall %}

  {{ return({'relations': relations}) }}

{%- endmaterialization -%}
