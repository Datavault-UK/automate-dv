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
