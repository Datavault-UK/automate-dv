{%- macro PIT(src_pk,src_ldts,src_payload) -%}

    {{- adapter.dispatch('PIT', packages = var('adapter_packages', ['dbtvault']))(src_pk=src_pk, src_ldts=src_ldts,
                                                                                  src_payload=src_payload,
                                                                                  source_model=source_model) -}}

{%- endmacro -%}