{% macro is_bridge_incremental() %}
    {#-- do not run introspective queries in parsing #}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

            {{ return(relation is not none
                      and relation.type == 'table'
                      and model.config.materialized == 'bridge_incremental'
                      and not flags.FULL_REFRESH) }}
    {% endif %}
{% endmacro %}

{% macro incremental_bridge_replace(tmp_relation, target_relation, statement_name="main") %}
    {%- set dest_columns = adapter.get_columns_in_relation(target_relation) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') -%}

    TRUNCATE TABLE {{ target_relation }};

    INSERT INTO {{ target_relation }} ({{ dest_cols_csv }})
    (
       SELECT {{ dest_cols_csv }}
       FROM {{ tmp_relation }}
    );
{%- endmacro %}
