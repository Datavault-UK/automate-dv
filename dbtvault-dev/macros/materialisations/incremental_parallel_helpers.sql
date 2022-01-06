{% macro is_vault_incremental_parallel() %}
    {#-- do not run introspective queries in parsing #}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

            {{ return(relation is not none
                      and relation.type == 'table'
                      and model.config.materialized == 'vault_incremental_parallel'
                      and not flags.FULL_REFRESH) }}
    {% endif %}
{% endmacro %}
