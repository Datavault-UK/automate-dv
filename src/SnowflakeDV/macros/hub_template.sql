{%- macro hub_template(src_table, src_pk, src_nk, src_source, src_ldts, tgt_pk, tgt_nk, tgt_source, tgt_ldts, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_pk, tgt_nk, tgt_source, tgt_ldts]) }}
 FROM (
  SELECT DISTINCT {{ snow_vault.prefix([src_pk, src_nk, src_source, src_ldts], 'b') }}
  FROM (
    SELECT {{ snow_vault.prefix([src_pk, src_nk, src_source, src_ldts], 'a') }}
    FROM {{ hash_model }} AS a
    LEFT JOIN {{ this }} AS c
    ON {{ snow_vault.prefix(src_pk, 'a') }} = c.{{ tgt_pk|last }})
 AS b)
AS stg
WHERE {{ snow_vault.prefix(src_pk, 'stg') }} NOT IN (SELECT {{ tgt_pk|last }} FROM {{ this }})

{%- endmacro -%}