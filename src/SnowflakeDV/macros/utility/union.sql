{%- macro union(src_table, src_pk, src_nk, src_source, src_ldts, tgt_pk, hash_model) -%}

{%- for src in src_table -%}
    SELECT DISTINCT {{ snow_vault.prefix([
           src_pk[loop.index0],
           src_nk[loop.index0],
           src_source,
           src_ldts], 'a') }},
           lag(a.{{ src_source }}, 1)
           over(partition by a.{{ src_pk[loop.index0] }}
           order by a.{{ src_pk[loop.index0] }}) as FIRST_SOURCE
    FROM {{ hash_model }} AS a
    {% if is_incremental() -%}
    LEFT JOIN {{ this }} AS c
    ON a.{{ src_pk[loop.index0] }} = c.{{ tgt_pk }}
    AND c.{{ tgt_pk }} IS NULL
    {%- endif %}
    {% if not loop.last -%}
    UNION
    {% endif %}
{%- endfor -%}

{%- endmacro -%}