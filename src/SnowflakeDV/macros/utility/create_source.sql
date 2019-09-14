{%- macro create_source(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table, hash_model) -%}
{%- set letters='abcdefghijklmnopqrstuvwxyz' -%}
    {%- if src_table|length <= 1 -%}
      {{- snow_vault.single(src_pk, src_nk, src_ldts, src_source, tgt_pk) }}
      FROM {{ hash_model[0] }} AS {{ letters[0] }}
      {%- if is_incremental() %}
      LEFT JOIN {{ this }} AS tgt_{{ letters[0] }}
      ON {{ letters[0] }}.{{ src_pk[0] }} = tgt_{{ letters[0] }}.{{ tgt_pk }}
      AND tgt_{{ letters[0] }}.{{ tgt_pk }} IS NULL
    {%- else -%}

    {%- endif -%}

    {%- endif -%}

{%- endmacro -%}