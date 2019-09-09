{%- macro link_template(src_table, src_cols, src_pk, src_fk, src_ldts, src_source, tgt_pk, tgt_fk, tgt_ldts, tgt_source, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_pk, tgt_fk, tgt_source, tgt_ldts]) }}
 FROM (
    {{ snow_vault.union(src_table, src_cols, src_pk, src_fk, src_ldts, src_source,
      tgt_pk|last, hash_model) }}
 AS b)
AS stg
{% if is_incremental() -%}
WHERE stg.{{ tgt_pk|last }} NOT IN (SELECT {{ tgt_pk|last }} FROM {{ this }})
AND FIRST_SOURCE IS NULL
{%- endif -%}
{% endmacro %}