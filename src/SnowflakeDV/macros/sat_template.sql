{%- macro sat_template(src_table, src_pk, src_hash, src_fk, src_ldts, src_eff, src_source, tgt_cols, tgt_pk, tgt_hash, tgt_fk, tgt_ldts, tgt_eff, tgt_source, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_hash, tgt_pk, tgt_fk, tgt_ldts, tgt_eff, tgt_source]) }}
 FROM (
      SELECT DISTINCT {{ tgt_cols|join(", ") }},
           LAG({{ src_eff }}, 1)
           OVER(PARTITION by {{ tgt_hash|first }}
           ORDER BY {{ src_eff }}) AS LAST_SEEN
    {{ snow_vault.union(src_table, src_pk, src_fk, src_ldts, src_source,
    tgt_pk|last, hash_model, src_eff, src_hash) }}
 AS b)
AS stg
{% if is_incremental() -%}
WHERE stg.{{ tgt_hash|first }} NOT IN (SELECT {{ tgt_hash|last }} FROM {{ this }} AS {{ tgt_hash|first }})
AND LAST_SEEN IS NULL
{%- endif -%}
{% endmacro %}