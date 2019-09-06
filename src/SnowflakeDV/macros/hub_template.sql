{%- macro hub_template(src_table, src_cols, src_pk, src_nk, src_source, src_ldts, tgt_pk, tgt_nk, tgt_source, tgt_ldts, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_pk, tgt_nk, tgt_source, tgt_ldts]) }}
 FROM (
    {{ snow_vault.union(src_table, src_cols, src_pk, src_nk, src_source, src_ldts,
      tgt_pk|last, hash_model) }}
 AS b)
AS stg
WHERE FIRST_SOURCE IS NULL
{%- endmacro -%}