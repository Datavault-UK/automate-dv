{%- macro sat_template(src_pk, src_hashdiff, src_payload,
                       src_eff, src_ldts, src_source,
                       tgt_cols,
                       tgt_pk, tgt_hashdiff, tgt_payload,
                       tgt_eff, tgt_ldts, tgt_source,
                       src_table, source) -%}

SELECT DISTINCT {{ dbtvault.cast([tgt_hashdiff, tgt_pk, tgt_payload, tgt_ldts, tgt_eff, tgt_source], 'e') }}
FROM {{ source[0] }} AS e
{% if is_incremental() -%}
LEFT JOIN (
    SELECT {{ dbtvault.prefix(tgt_cols, 'd') }}
    FROM (
          SELECT {{ dbtvault.prefix(tgt_cols, 'c') }},
          CASE WHEN RANK()
          OVER (PARTITION BY {{ dbtvault.prefix([tgt_pk|last], 'c') }}
          ORDER BY {{ dbtvault.prefix([tgt_ldts|last], 'c') }} DESC) = 1
          THEN 'Y' ELSE 'N' END CURR_FLG
          FROM (
            SELECT {{ dbtvault.prefix(tgt_cols, 'a') }}
            FROM {{ this }} as a
            JOIN {{ source[0] }} as b
            ON {{ dbtvault.prefix([tgt_pk|last], 'a') }} = {{ dbtvault.prefix([src_pk], 'b') }}
          ) as c
    ) AS d
WHERE d.CURR_FLG = 'Y') AS src
ON {{ dbtvault.prefix([tgt_hashdiff|last], 'src') }} = {{ dbtvault.prefix([src_hashdiff], 'e') }}
WHERE {{ dbtvault.prefix([tgt_hashdiff|last], 'src') }} IS NULL
{%- endif -%}

{% endmacro %}