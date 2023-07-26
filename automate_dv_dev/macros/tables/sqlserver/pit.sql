/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro sqlserver__pit(src_pk, src_extra_columns, as_of_dates_table, satellites, stage_tables_ldts, src_ldts, source_model) -%}

{{- automate_dv.default__pit(src_pk=src_pk,
                             src_extra_columns=src_extra_columns,
                             as_of_dates_table=as_of_dates_table,
                             satellites=satellites,
                             stage_tables_ldts=stage_tables_ldts,
                             src_ldts=src_ldts,
                             source_model=source_model) -}}

{%- endmacro -%}
