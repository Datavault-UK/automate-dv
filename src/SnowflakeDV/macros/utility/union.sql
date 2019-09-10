{%- macro union(src_table, src_cols, src_pk, src_nk, src_ldts, src_source, tgt_pk, hash_model) -%}

 {% set letters='abcdefghijklmnopqrstuvwxyz' %}

    SELECT DISTINCT {{ src_cols|join(", ") }},
           LAG({{ src_source }}, 1)
           OVER(PARTITION by {{ src_pk[0] }}
           ORDER BY {{ src_pk[0] }}) AS FIRST_SOURCE
    FROM (
        {%- for src in src_table -%}

        {%- set letter = letters[loop.index0] -%}

        SELECT DISTINCT {{ snow_vault.prefix([
        src_pk[loop.index0],
        src_nk,
        src_ldts,
        src_source], letter ) }}
        {% if hash_model is none -%}
        FROM {{ src[loop.index0] }} AS {{ letter }}
        {% else -%}
        FROM {{ hash_model }} AS {{ letter }}
        {%- endif %}
        {% if is_incremental() -%}
        LEFT JOIN {{ this }} AS tgt_{{ letter }}
        ON {{ letter }}.{{ src_pk[loop.index0] }} = tgt_{{ letter }}.{{ tgt_pk }}
        AND tgt_{{ letter }}.{{ tgt_pk }} IS NULL
        {%- endif %}
        {% if not loop.last -%}
        UNION
        {% endif %}
        {%- endfor %})
{%- endmacro -%}