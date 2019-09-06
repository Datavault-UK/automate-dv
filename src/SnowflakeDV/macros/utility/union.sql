{%- macro union(src_table, src_cols, src_pk, src_nk, src_ldts, src_source, tgt_pk, hash_model) -%}
    SELECT DISTINCT {{ src_cols }},
           lag({{ src_source }}, 1)
           over(partition by {{ src_pk[0] }}
           order by {{ src_pk[0] }}) as FIRST_SOURCE
    FROM (
        {%- for src in src_table -%}
        SELECT DISTINCT {{ snow_vault.prefix([
        src_pk[loop.index0],
        src_nk[loop.index0],
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