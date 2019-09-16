{%- macro link_template(src_pk, src_fk, src_ldts, src_source,
                        tgt_cols, tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                        src_table, hash_model) -%}

SELECT DISTINCT {{ snow_vault.cast([tgt_pk, tgt_fk, tgt_ldts, tgt_source]) }}
FROM (
    {{ snow_vault.create_source(src_pk, src_fk, src_ldts, src_source, tgt_cols, tgt_pk|first,
                                src_table or none, hash_model or none) }}
 ) AS stg
{% if is_incremental() -%}
WHERE stg.{{ tgt_pk|last }} NOT IN (SELECT {{ tgt_pk|last }} FROM {{ this }})
AND FIRST_SOURCE IS NULL
{%- endif -%}

{%- endmacro -%}