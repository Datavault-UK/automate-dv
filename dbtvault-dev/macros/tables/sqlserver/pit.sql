{%- macro sqlserver__pit(src_pk, as_of_dates_table, satellites, stage_tables, src_ldts, source_model) -%}

{{ dbtvault.default__pit(source_model=source_model, src_pk=src_pk,
                         as_of_dates_table=as_of_dates_table,
                         satellites=satellites,
                         stage_tables=stage_tables,
                         src_ldts=src_ldts)  }}

{%- endmacro -%}