{%- macro single(src_pk, src_nk, src_ldts, src_source, tgt_pk,
                 source, letter='a') -%}

      SELECT {{ dbtvault.prefix([src_pk, src_nk, src_ldts, src_source], letter) }}
      FROM {{ source }} AS {{ letter }}
{%- endmacro -%}