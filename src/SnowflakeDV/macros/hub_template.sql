{%- macro hub_template(src_table, src_cols, src_pk, src_nk, src_source, src_ldts, tgt_pk, tgt_nk, tgt_source, tgt_ldts, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_pk, tgt_nk, tgt_source, tgt_ldts]) }}
 FROM (
  SELECT DISTINCT {{ src_cols }}, FIRST_SOURCE
  FROM
    ({{ snow_vault.union(src_table, src_pk, src_nk, src_source, src_ldts, tgt_pk|last, hash_model) }})
 AS b)
AS stg
{% if is_incremental() -%}
WHERE {{ snow_vault.prefix(src_pk[0], 'stg') }} NOT IN (SELECT {{ tgt_pk|last }} FROM {{ this }})
AND FIRST_SOURCE IS NULL
{%- endif -%}
{%- endmacro -%}