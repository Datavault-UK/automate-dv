{%- macro sat_template(src_pk, src_hashdiff, src_payload,
                       src_eff, src_ldts, src_source,
                       tgt_pk, tgt_hashdiff, tgt_payload,
                       tgt_eff, tgt_ldts, tgt_source,
                       src_table, hash_model) -%}

SELECT DISTINCT {{ snow_vault.cast([tgt_hashdiff, tgt_pk, tgt_payload, tgt_ldts, tgt_eff, tgt_source]) }}
 FROM (
      SELECT {{ snow_vault.prefix([src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source], 'a') }},
        LEAD({{ snow_vault.prefix([src_ldts], 'a') }}, 1)
        OVER(PARTITION by {{ snow_vault.prefix([tgt_pk|first], 'a') }}
        ORDER BY {{ snow_vault.prefix([src_ldts], 'a') }}) AS LAST_SEEN
        FROM {{ hash_model }} AS a
        {%- if is_incremental() %}
        LEFT JOIN {{ this }} AS tgt_a
        ON a.{{ src_hashdiff }} = tgt_a.{{ tgt_hashdiff|last }}
        WHERE tgt_a.{{ tgt_hashdiff|last }} IS NULL
        {%- endif %}
 ) AS src
WHERE LAST_SEEN IS NULL
{% endmacro %}