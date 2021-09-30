{#-- Helper macros for rank materializations #}

{#-- MULTI-DISPATCH MACROS #}

{#-- REPLACE_PLACEHOLDER_WITH_RANK_FILTER #}

{%- macro replace_placeholder_with_rank_filter(core_sql, rank_column, rank_iteration) -%}

    {% set macro = adapter.dispatch('replace_placeholder_with_rank_filter',
                                    'dbtvault')(core_sql=core_sql,
                                                rank_column=rank_column,
                                                rank_iteration=rank_iteration) %}
    {% do return(macro) %}
{%- endmacro %}

{% macro default__replace_placeholder_with_rank_filter(core_sql, rank_column, rank_iteration) %}

    {%- set rank_filter -%}
        {{ rank_column }}::INTEGER = {{ rank_iteration }}::INTEGER
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__RANK_FILTER__", rank_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}


{#-- OTHER MACROS #}

{% macro get_min_max_ranks(rank_column, rank_source_models) %}

    {% if rank_source_models is not none %}

        {% if rank_source_models is string %}
            {% set rank_source_models = [rank_source_models] %}
        {% endif %}

        {% set query_sql %}
            WITH stage AS (
            {% for source_model in rank_source_models %}
                SELECT {{ rank_column }} FROM {{ ref(source_model) }}
                {% if not loop.last %} UNION ALL {% endif %}
            {% endfor %})

            SELECT MIN({{ rank_column }}) AS MIN, MAX({{ rank_column }}) AS MAX
            FROM stage
        {% endset %}

        {% set min_max_dict = dbt_utils.get_query_results_as_dict(query_sql) %}

        {% set min_rank = min_max_dict['MIN'][0] | string %}
        {% set max_rank = min_max_dict['MAX'][0] | string %}
        {% set min_max_ranks = {"min_rank": min_rank, "max_rank": max_rank} %}

        {% do return(min_max_ranks) %}

    {% else %}
        {%- if execute -%}
            {{ exceptions.raise_compiler_error("Invalid 'vault_insert_by_rank' configuration. Must provide 'rank_column', and 'rank_source_models' options.") }}
        {%- endif -%}
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
                      and not flags.FULL_REFRESH) }}
    {% endif %}
{% endmacro %}
