{%- macro create_source(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk,
                        hash_model) -%}

    {%- if hash_model|length == 1 -%}

        {{- snow_vault.single(src_pk, src_nk, src_ldts, src_source, tgt_pk, hash_model[0], 'a', false) -}}

    {%- elif hash_model|length > 1 -%}

        {{- snow_vault.union(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk, hash_model) -}}

    {%- endif -%}

{%- endmacro -%}