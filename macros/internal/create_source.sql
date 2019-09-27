{%- macro create_source(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk,
                        source, is_union) -%}

    {%- if not is_union -%}

        {{- dbtvault.single(src_pk, src_nk, src_ldts, src_source, tgt_pk, source[0], 'a') -}}

    {%- else -%}

        {{- dbtvault.union(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk, source) -}}

    {%- endif -%}

{%- endmacro -%}