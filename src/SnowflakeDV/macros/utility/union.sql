{%- macro union(src_table, src_cols, src_pk, src_nk, src_ldts, src_source, tgt_pk, hash_model) -%}
    SELECT DISTINCT {{ src_cols }},
           LAG({{ src_source }}, 1)
           OVER(PARTITION by {{ src_pk[0] }}
           ORDER BY {{ src_pk[0] }}) AS FIRST_SOURCE
    FROM (
        {%- for src in src_table -%}
        SELECT DISTINCT {{ snow_vault.prefix([
        src_pk[loop.index0],
        src_nk,
        src_ldts,
        src_source], 'a') }}
        FROM {{ hash_model }} AS a
        {% if is_incremental() -%}
        LEFT JOIN {{ this }} AS c
        ON a.{{ src_pk[loop.index0] }} = c.{{ tgt_pk }}
        AND c.{{ tgt_pk }} IS NULL
        {%- endif %}
        {% if not loop.last -%}
        UNION
        {% endif %}
        {%- endfor %})
{%- endmacro -%}