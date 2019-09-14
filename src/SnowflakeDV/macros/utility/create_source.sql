{%- macro create_source(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table, hash_model) -%}

{%- set letters='abcdefghijklmnopqrstuvwxyz' -%}

    SELECT DISTINCT

    {% if src_table|length <= 1 -%}
    {{- snow_vault.prefix([src_pk, src_nk, src_ldts, src_source], letters[0]) -}},
    LAG({{ letters[0] }}.{{ src_source }}, 1)
    OVER(PARTITION by {{ letters[0] }}.{{ tgt_pk }}
    ORDER BY {{ letters[0] }}.{{ tgt_pk }}) AS FIRST_SOURCE
    {%- endif %}
    FROM {{ hash_model[0] }} AS {{ letters[0] }}

    {%- if is_incremental() %}
    LEFT JOIN {{ this }} AS tgt_{{ letters[0] }}
    ON {{ letters[0] }}.{{ src_pk[0] }} = tgt_{{ letters[0] }}.{{ tgt_pk }}
    AND tgt_{{ letters[0] }}.{{ tgt_pk }} IS NULL
    {% endif -%}

{%- endmacro -%}