{%- macro single(src_pk, src_nk, src_ldts, src_source, tgt_pk) -%}

      SELECT DISTINCT {{ snow_vault.prefix([src_pk, src_nk, src_ldts, src_source], 'a' ) }},
      LAG(a.{{ src_source }}, 1)
      OVER(PARTITION by a.{{ tgt_pk }}
      ORDER BY a.{{ tgt_pk }}) AS FIRST_SOURCE

{%- endmacro -%}