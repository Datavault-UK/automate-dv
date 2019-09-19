{%- macro union(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk, hash_model) -%}

    {%- if is_incremental() -%}
    SELECT {{ tgt_cols|join(", ") }},
    LAG({{ src_source }}, 1)
    OVER(PARTITION by {{ tgt_pk }}
    ORDER BY {{ tgt_pk }}) AS FIRST_SOURCE
    FROM (
    {%- endif -%}

 {%- set letters='abcdefghijklmnopqrstuvwxyz' -%}

      {%- set iterations = hash_model|length -%}

      {%- for src in range(iterations) -%}
      {%- set letter = letters[loop.index0] %}
      {{ snow_vault.single(src_pk[loop.index0], src_nk[loop.index0], src_ldts, src_source,
                            tgt_pk,
                            hash_model[loop.index0],
                            letter,
                            union=true) -}}
      {% if not loop.last %}
      UNION
      {%- endif -%}
      {%- endfor -%}{%- if is_incremental() -%}){%- endif -%}
{%- endmacro -%}