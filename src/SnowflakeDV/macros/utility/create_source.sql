{%- macro create_source(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table, hash_model) -%}

    {{ log(src_table, true) }}
    {%- if src_table and src_table|length == 1 -%}
      {{- snow_vault.single(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table, hash_model) }}

    {%- elif src_table|length > 1 or hash_model|length > 1 -%}

    {{ log("union", true)}}
        {{- snow_vault.union(src_pk, src_nk, src_ldts, src_source, tgt_pk, src_table, hash_model) }}
    {%- endif -%}

{%- endmacro -%}