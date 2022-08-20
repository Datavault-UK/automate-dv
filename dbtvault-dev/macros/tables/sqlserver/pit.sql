{%- macro sqlserver__pit(src_pk, src_extra_columns, as_of_dates_table, satellites, stage_tables_ldts, src_ldts, source_model) -%}

{{ dbtvault.default__pit(src_pk=src_pk,
                         src_extra_columns=src_extra_columns,
                         as_of_dates_table=as_of_dates_table,
                         satellites=satellites,
                         stage_tables_ldts=stage_tables_ldts,
                         src_ldts=src_ldts,
                         source_model=source_model) }}

{%- endmacro -%}
