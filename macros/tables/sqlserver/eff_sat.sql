/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro sqlserver__eff_sat(src_pk, src_dfk, src_sfk, src_extra_columns, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

{{- automate_dv.default__eff_sat(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                 src_extra_columns=src_extra_columns,
                                 src_start_date=src_start_date, src_end_date=src_end_date,
                                 src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                 source_model=source_model) -}}

{%- endmacro -%}