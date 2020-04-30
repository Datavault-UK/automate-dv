{%- macro multiperiod_hub(src_pk, src_nk, src_ldts, src_source,
              source) -%}
{%- set source_data = dbtvault.is_multi_source(source, src_pk, src_nk, src_ldts, src_source) -%}
{%- set source_col = source_data[0] -%}
{%- set is_union = source_data[1] -%}
SELECT {{ dbtvault.prefix([src_pk, src_nk, src_ldts, src_source], 'stg') }}
FROM
(
    SELECT ROW_NUMBER()
    OVER (PARTITION BY b.{{ src_pk }}
    ORDER BY {{ dbtvault.prefix([src_ldts, src_source], 'b') }}) AS RowNum,
    {{ dbtvault.prefix([src_pk, src_nk, src_ldts, src_source], 'b') }}
    FROM (
        {{ source_col }}
    ) AS b
    WHERE {{ dbtvault.prefix([src_nk], 'b') }} IS NOT NULL
    {# If a union base-load #}
    {%- if is_union -%}
    AND b.FIRST_SOURCE IS NULL
    {%- endif -%}
) AS stg
{%- if is_incremental() %}
    LEFT JOIN {{ this }} AS tgt
    ON {{ dbtvault.prefix([src_pk], 'stg') }} = {{ dbtvault.prefix([src_pk], 'tgt') }}
    WHERE {{ dbtvault.prefix([src_pk], 'tgt') }} IS NULL
    AND stg.RowNum = 1
    AND {{ dbtvault.prefix([src_pk], 'stg') }} <> {{ dbtvault.hash_check("''") }}
{% else %}
WHERE stg.RowNum = 1
{%- endif %}
AND {{ dbtvault.prefix([src_pk], 'stg') }} <> {{ dbtvault.hash_check("''") }}
{%- endmacro -%}