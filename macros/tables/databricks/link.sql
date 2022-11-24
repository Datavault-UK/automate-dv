{%- macro databricks__link(src_pk, src_fk, src_extra_columns, src_ldts, src_source, source_model) -%}

{{ dbtvault.default__link(src_pk=src_pk,
                          src_fk=src_fk,
                          src_extra_columns=src_extra_columns,
                          src_ldts=src_ldts,
                          src_source=src_source,
                          source_model=source_model) }}

{%- endmacro -%}
