{%- macro create_table_as(temporary, relation, sql) -%}

    {% set macro = adapter.dispatch('create_table_as',
                                    packages = dbtvault.get_dbtvault_namespaces())(temporary=temporary,
                                                                                   relation=relation,
                                                                                   sql=sql) %}
    {% do return(macro) %}
{%- endmacro %}

{% macro default__create_table_as(temporary, relation, sql) -%}

    {{ dbt.create_table_as(temporary, relation, sql) }}

{%- endmacro %}

{% macro sqlserver__create_table_as(temporary, relation, sql) -%}
    {%- set as_columnstore = config.get('as_columnstore', default=true) -%}
    {% set tmp_relation = relation.incorporate(
        path={"identifier": relation.identifier.replace("#", "") ~ '_temp_view'},
        type='view') -%}
    {%- set temp_view_sql = sql.replace("'", "''") -%}

    {% if relation.identifier.startswith('#') -%}
        {# Temporary tables are a special case in MSSQL: they are always in database 'tempdb' and technically schemaless #}
        {# However dbt seems to require a schema and in this case using either 'dbo' or the current schema will work #}
       {% set relation = relation.create(
            database='tempdb', schema=relation.schema, identifier=relation.identifier, type='table')-%}
    {% endif -%}

    {% if relation.type == None -%}
        {% set relation = relation.incorporate(type='table') -%}
    {% endif -%}

    {{ sqlserver__drop_relation_script(tmp_relation) }}

    {{ sqlserver__drop_relation_script(relation) }}

    USE [{{ tmp_relation.database }}];
    EXEC('CREATE VIEW {{ tmp_relation.include(database=False) }} AS
    {{ temp_view_sql }}
    ');

    SELECT * INTO {{ relation }} FROM
    {{ tmp_relation }}

    {{ sqlserver__drop_relation_script(tmp_relation) }}

    {% if not temporary and as_columnstore -%}
    {{ sqlserver__create_clustered_columnstore_index(relation) }}
    {% endif %}

{% endmacro %}