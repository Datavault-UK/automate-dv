{%- macro union(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk, source) -%}

    SELECT {{ tgt_cols|join(", ") }}{% if is_incremental() or union -%},
    LAG({{ src_source }}, 1)
    OVER(PARTITION by {{ tgt_pk }}
    ORDER BY {{ tgt_pk }}) AS FIRST_SOURCE
    {%- endif %}
    FROM (

 {%- set letters='abcdefghijklmnopqrstuvwxyz' -%}

      {%- set iterations = source|length -%}

      {%- for src in range(iterations) -%}
      {%- set letter = letters[loop.index0] %}
      {{ dbtvault.single(src_pk[loop.index0], src_nk[loop.index0], src_ldts, src_source,
                         tgt_pk, source[loop.index0], letter) -}}
      {% if not loop.last %}
      UNION
      {%- endif -%}
      {%- endfor -%})
{%- endmacro -%}