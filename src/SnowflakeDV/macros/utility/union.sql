{%- macro union(src_pk, src_nk, src_source, src_ldts, tgt_pk, hash_model) -%}

{%- for src in src_source -%}
    SELECT {{ snow_vault.prefix([src_pk[loop.index0], src_nk[loop.index0], src_source[loop.index0], src_ldts[loop.index0]], 'a') }}
    FROM {{ hash_model[loop.index0] }} AS a
    LEFT JOIN {{ this }} AS c
    ON a.CUSTOMER_PK = c.CUSTOMER_PK
    AND c.CUSTOMER_PK IS NULL
    {% if not loop.last -%}
    UNION
    {% endif %}
{%- endfor -%}

{%- endmacro -%}