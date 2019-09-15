{%- macro single(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table=none, hash_model=none, letter='a') -%}

      SELECT DISTINCT {{ snow_vault.prefix([src_pk, src_nk, src_ldts, src_source], letter) }},
      LAG({{ letter }}.{{ src_source }}, 1)
      OVER(PARTITION by {{ letter }}.{{ tgt_pk }}
      ORDER BY {{ letter }}.{{ tgt_pk }}) AS FIRST_SOURCE
      {% if hash_model -%}
      FROM {{ hash_model[0] }} AS {{ letter }}
      {% else -%}
      FROM {{ hash_model[0] }} AS {{ letter }}
      {%- endif -%}
      {%- if is_incremental() %}
      LEFT JOIN {{ this }} AS tgt_{{ letter }}
      ON {{ letter }}.{{ src_pk[0] }} = tgt_{{ letter }}.{{ tgt_pk }}
      AND tgt_{{ letter }}.{{ tgt_pk }} IS NULL
      {%- endif -%}
{%- endmacro -%}