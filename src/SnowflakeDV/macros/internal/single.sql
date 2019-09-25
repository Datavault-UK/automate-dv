{%- macro single(src_pk, src_nk, src_ldts, src_source, tgt_pk,
                 hash_model, letter='a', union=false) -%}

      SELECT {{ dbtvault.prefix([src_pk, src_nk, src_ldts, src_source], letter) -}}
      {% if not union %}
      ,LAG({{ letter }}.{{ src_source }}, 1)
      OVER(PARTITION by {{ dbtvault.prefix([tgt_pk], letter) }}
      ORDER BY {{ dbtvault.prefix([tgt_pk], letter) }}) AS FIRST_SOURCE
      {%- endif -%}
      {%- if hash_model %}
      FROM {{ hash_model }} AS {{ letter }}
      {%- else %}
      FROM {{ src_table }} AS {{ letter }}
      {%- endif -%}
      {%- if is_incremental() %}
      LEFT JOIN {{ this }} AS tgt_{{ letter }}
      ON {{ dbtvault.prefix([src_pk], letter) }} = tgt_{{ dbtvault.prefix([tgt_pk], letter) }}
      AND tgt_{{ dbtvault.prefix([tgt_pk], letter) }} IS NULL
      {%- endif -%}
{%- endmacro -%}