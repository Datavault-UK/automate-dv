{%- macro create_source(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk,
                        src_table, hash_model) -%}

    {%- if (src_table and src_table|length == 1) or (hash_model and hash_model|length == 1) -%}

        {{- snow_vault.single(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table[0] or none, hash_model[0] or none, 'a', false) -}}

    {%- elif (src_table and src_table|length > 1) or (hash_model and hash_model|length > 1) -%}

        {{- snow_vault.union(src_pk, src_nk, src_ldts, src_source, tgt_cols, tgt_pk, src_table or none, hash_model or none) -}}

    {%- endif -%}

{%- endmacro -%}