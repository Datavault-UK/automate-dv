{%- macro link_template(src_table, src_pk, src_fk, src_ldts, src_source,
                        tgt_cols, tgt_pk, tgt_fk, tgt_ldts, tgt_source, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_pk, tgt_fk, tgt_ldts, tgt_source]) }}
 FROM (
      SELECT DISTINCT {{ tgt_cols|join(", ") }},
           LAG({{ src_source }}, 1)
           OVER(PARTITION by {{ tgt_pk[0] }}
           ORDER BY {{ tgt_pk[0] }}) AS FIRST_SOURCE
    {{ snow_vault.create_source(src_table, src_pk, src_fk, src_ldts, src_source,
      tgt_pk|last, hash_model) }} AS src
) AS stg
{% if is_incremental() -%}
WHERE stg.{{ tgt_pk|last }} NOT IN (SELECT {{ tgt_pk|last }} FROM {{ this }})
AND FIRST_SOURCE IS NULL
{%- endif -%}

{%- endmacro -%}