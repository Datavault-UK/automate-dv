{%- macro databricks__hub(src_pk, src_nk, src_extra_columns, src_ldts, src_source, source_model) -%}

{{ dbtvault.default__hub(src_pk=src_pk,
                         src_nk=src_nk,
                         src_extra_columns=src_extra_columns,
                         src_ldts=src_ldts,
                         src_source=src_source,
                         source_model=source_model) }}

{%- endmacro -%}