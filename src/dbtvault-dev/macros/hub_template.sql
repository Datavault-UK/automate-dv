{%- macro hub_template(src_pk, src_nk, src_ldts, src_source,
                       tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                       source) -%}

{%- set is_union = true if source|length > 1 else false -%}

SELECT DISTINCT {{ dbtvault.cast([tgt_pk, tgt_nk, tgt_ldts, tgt_source], 'stg') }}
FROM (
    {{ dbtvault.create_source(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk|last,
                              source, is_union) }}
) AS stg
{% if is_incremental() or is_union -%}
LEFT JOIN {{ this }} AS tgt
ON {{ dbtvault.prefix([tgt_pk|last], 'stg') }} = {{ dbtvault.prefix([tgt_pk|last], 'tgt') }}
WHERE {{ dbtvault.prefix([tgt_pk|last], 'tgt') }} IS NULL
{%- if is_union %}
AND stg.FIRST_SOURCE IS NULL
{%- endif -%}
{%- endif -%}
{%- endmacro -%}