{%- macro single(src_pk, src_nk, src_ldts, src_source, tgt_pk,
                 src_table=none, hash_model=none, letter='a',
                 union=false) -%}

      SELECT DISTINCT {{ snow_vault.prefix([src_pk, src_nk, src_ldts, src_source], letter) -}}
      {% if not union %}
      ,LAG({{ letter }}.{{ src_source }}, 1)
      OVER(PARTITION by {{ snow_vault.prefix([tgt_pk], letter) }}
      ORDER BY {{ snow_vault.prefix([tgt_pk], letter) }}) AS FIRST_SOURCE
      {%- endif -%}
      {%- if hash_model %}
      FROM {{ hash_model }} AS {{ letter }}
      {%- else %}
      FROM {{ src_table }} AS {{ letter }}
      {%- endif -%}
      {%- if is_incremental() %}
      LEFT JOIN {{ this }} AS tgt_{{ letter }}
      ON {{ snow_vault.prefix([src_pk], letter) }} = tgt_{{ snow_vault.prefix([tgt_pk], letter) }}
      AND tgt_{{ snow_vault.prefix([tgt_pk], letter) }} IS NULL
      {%- endif -%}
{%- endmacro -%}