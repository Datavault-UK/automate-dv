/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro is_any_incremental() -%}
    {%- if automate_dv.is_vault_insert_by_period() or automate_dv.is_vault_insert_by_rank() or automate_dv.is_pit_incremental() or automate_dv.is_bridge_incremental() or is_incremental() -%}
        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}
{%- endmacro -%}



{% macro is_vault_insert_by_period() %}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

            {{ return(relation is not none
                      and relation.type == 'table'
                      and model.config.materialized == 'vault_insert_by_period'
                      and not should_full_refresh()) }}
    {% endif %}
{% endmacro %}



{% macro is_vault_insert_by_rank() %}
    {#-- do not run introspective queries in parsing #}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

            {{ return(relation is not none
                      and relation.type == 'table'
                      and model.config.materialized == 'vault_insert_by_rank'
                      and not should_full_refresh()) }}
    {% endif %}
{% endmacro %}



{% macro is_bridge_incremental() %}
    {#-- do not run introspective queries in parsing #}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

            {{ return(relation is not none
                      and relation.type == 'table'
                      and model.config.materialized == 'bridge_incremental'
                      and not should_full_refresh()) }}
    {% endif %}
{% endmacro %}



{% macro is_pit_incremental() %}
    {#-- do not run introspective queries in parsing #}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

            {{ return(relation is not none
                      and relation.type == 'table'
                      and model.config.materialized == 'pit_incremental'
                      and not should_full_refresh()) }}
    {% endif %}
{% endmacro %}