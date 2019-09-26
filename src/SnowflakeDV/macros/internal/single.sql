{%- macro single(src_pk, src_nk, src_ldts, src_source, tgt_pk,
                 hash_model, letter='a', union=false) -%}

      SELECT {{ dbtvault.prefix([src_pk, src_nk, src_ldts, src_source], letter) -}}
      {%- if hash_model %}
      FROM {{ hash_model }} AS {{ letter }}
      {%- else %}
      FROM {{ src_table }} AS {{ letter }}
      {%- endif %}
      LEFT JOIN {{ this }} AS tgt_{{ letter }}
      ON {{ dbtvault.prefix([src_pk], letter) }} = tgt_{{ dbtvault.prefix([tgt_pk], letter) }}
      WHERE tgt_{{ dbtvault.prefix([tgt_pk], letter) }} IS NULL
{%- endmacro -%}