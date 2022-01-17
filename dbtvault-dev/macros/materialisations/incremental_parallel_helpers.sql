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


{% macro get_merge_insert_sql(target, source, unique_key, dest_columns, predicates=none) -%}
  {{ adapter.dispatch('get_merge_insert_sql', 'dbtvault')(target, source, unique_key, dest_columns, predicates) }}
{%- endmacro %}

{% macro default__get_merge_insert_sql(target, source, unique_key, dest_columns, predicates) -%}
    {%- set predicates = [] if predicates is none else [] + predicates -%}
    {%- set dest_cols_csv = get_quoted_csv(dest_columns | map(attribute="name")) -%}
    {%- set update_columns = config.get('merge_update_columns', default = dest_columns | map(attribute="quoted") | list) -%}
    {%- set sql_header = config.get('sql_header', none) -%}

    {% if unique_key %}
        {% set unique_key_match %}
            DBT_INTERNAL_SOURCE.{{ unique_key }} = DBT_INTERNAL_DEST.{{ unique_key }}
        {% endset %}
        {% do predicates.append(unique_key_match) %}
    {% else %}
        {% do predicates.append('FALSE') %}
    {% endif %}

    {{ sql_header if sql_header is not none }}

    merge into {{ target }} as DBT_INTERNAL_DEST
        using {{ source }} as DBT_INTERNAL_SOURCE
        on {{ predicates | join(' and ') }}

{#    {% if unique_key %}#}
{#    when matched then update set#}
{#        {% for column_name in update_columns -%}#}
{#            {{ column_name }} = DBT_INTERNAL_SOURCE.{{ column_name }}#}
{#            {%- if not loop.last %}, {%- endif %}#}
{#        {%- endfor %}#}
{#    {% endif %}#}

    when not matched then insert
        ({{ dest_cols_csv }})
    values
        ({{ dest_cols_csv }})

{% endmacro %}