{%- macro hub_template(src_table, src_pk, src_nk, tgt_pk, tgt_nk, hash_model) -%}

SELECT {{ tgt_pk }}, {{ tgt_nk }}
 FROM (
  SELECT DISTINCT {{ snow_vault.prefix(src_pk, 'b')}}, {{ snow_vault.prefix(src_nk, 'b') }}
  FROM (
    SELECT {{ snow_vault.prefix(src_pk, 'a') }}, {{ snow_vault.prefix(src_nk, 'a') }}
    FROM {{ hash_model }} AS a
    LEFT JOIN {{ this }} AS c
    ON {{ snow_vault.prefix(src_pk, 'a') }} = c.{{ tgt_pk }}
    AND c.{{ tgt_pk }} IS NULL)
 AS b)
AS stg

{%- endmacro -%}