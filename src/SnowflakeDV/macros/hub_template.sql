{%- macro hub_template(src_pk, src_nk, src_ldts, src_source,
                       tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                       src_table=none, hash_model=none) -%}

SELECT {{ snow_vault.cast([tgt_pk, tgt_nk, tgt_ldts, tgt_source]) }}
 FROM (
      {%- if src_table -%}
        {{ snow_vault.create_source(src_pk, src_nk, src_ldts, src_source, tgt_pk|last,
                                    src_table, hash_model) }}
      {%- endif -%}
) AS stg
{% if is_incremental() -%}
WHERE stg.{{ tgt_pk|last }} NOT IN (SELECT {{ tgt_pk|last }} FROM {{ this }})
AND FIRST_SOURCE IS NULL
{%- endif -%}

{%- endmacro -%}