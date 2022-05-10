{%- macro bigquery__t_link(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model) -%}

{{ dbtvault.default__t_link(src_pk=src_pk, src_fk=src_fk, src_payload=src_payload,
                            src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                            source_model=source_model) }}

{%- endmacro -%}