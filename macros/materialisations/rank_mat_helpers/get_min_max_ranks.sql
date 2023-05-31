/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

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

        {% set min_max_dict = automate_dv.get_query_results_as_dict(query_sql) %}

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
