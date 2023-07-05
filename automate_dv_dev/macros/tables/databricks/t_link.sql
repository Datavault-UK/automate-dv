/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro databricks__t_link(src_pk, src_fk, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{{- automate_dv.default__t_link(src_pk=src_pk, src_fk=src_fk, src_payload=src_payload,
                                src_extra_columns=src_extra_columns,
                                src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                source_model=source_model) -}}

{%- endmacro -%}
