{%- macro sat_template(src_table, src_pk, src_hash, src_fk, src_ldts, src_eff, src_source,
                       tgt_cols, tgt_pk, tgt_hash, tgt_fk, tgt_ldts, tgt_eff, tgt_source, hash_model) -%}

SELECT {{ snow_vault.cast([tgt_hash, tgt_pk, tgt_fk, tgt_ldts, tgt_eff, tgt_source]) }}
 FROM (
      SELECT DISTINCT {{ snow_vault.prefix(tgt_cols, 'a') }},
        LEAD({{ snow_vault.prefix([src_eff], 'a') }}, 1)
        OVER(PARTITION by {{ snow_vault.prefix([tgt_pk|first], 'a') }}
        ORDER BY {{ snow_vault.prefix([src_eff], 'a') }}) AS LAST_SEEN
        {%- if is_incremental() %}
        FROM {{ hash_model }} AS a
        LEFT JOIN {{ this }} AS tgt_a
        ON a.{{ src_pk }} = tgt_a.{{ tgt_pk|last }}
        AND tgt_a.{{ tgt_pk|last }} IS NULL
        {%- endif %}
 ) AS src
{% if is_incremental() -%}
WHERE src.{{ tgt_hash|first }} NOT IN (SELECT {{ tgt_hash|last }} FROM {{ this }} AS {{ tgt_hash|first }})
AND LAST_SEEN IS NULL
{%- endif -%}
{% endmacro %}