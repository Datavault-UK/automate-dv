{%- macro msat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                                                               src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                                               src_source=src_source, source_model=source_model) -}}

{%- endmacro %}

{%- macro default__msat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

{%- endmacro -%}