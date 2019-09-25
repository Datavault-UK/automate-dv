{%- macro sat_template(src_pk, src_hashdiff, src_payload,
                       src_eff, src_ldts, src_source,
                       tgt_cols,
                       tgt_pk, tgt_hashdiff, tgt_payload,
                       tgt_eff, tgt_ldts, tgt_source,
                       src_table, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_hashdiff, tgt_pk, tgt_payload, tgt_ldts, tgt_eff, tgt_source], 'e') }}
FROM {{ hash_model }} AS e
{% if is_incremental() -%}
LEFT JOIN (
    SELECT {{ snow_vault.prefix(tgt_cols, 'd') }}
    FROM (
          SELECT {{ snow_vault.prefix(tgt_cols, 'c') }},
          CASE WHEN RANK()
          OVER (PARTITION BY {{ snow_vault.prefix([tgt_pk|last], 'c') }}
          ORDER BY {{ snow_vault.prefix([tgt_ldts|last], 'c') }} DESC) = 1
          THEN 'Y' ELSE 'N' END CURR_FLG
          FROM (
            SELECT {{ snow_vault.prefix(tgt_cols, 'a') }}
            FROM {{ this }} as a
            JOIN {{ hash_model }} as b
            ON {{ snow_vault.prefix([tgt_pk|last], 'a') }} = {{ snow_vault.prefix([src_pk], 'b') }}
          ) as c
    ) AS d
WHERE d.CURR_FLG = 'Y') AS src
ON {{ snow_vault.prefix([tgt_hashdiff|last], 'src') }} = {{ snow_vault.prefix([src_hashdiff], 'e') }}
WHERE {{ snow_vault.prefix([tgt_hashdiff|last], 'src') }} IS NULL
{%- endif -%}

{% endmacro %}