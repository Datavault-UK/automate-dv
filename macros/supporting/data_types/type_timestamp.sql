/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro type_timestamp() -%}
  {{- return(adapter.dispatch('type_timestamp', 'automate_dv')()) -}}
{%- endmacro -%}

{%- macro default__type_timestamp() -%}
    TIMESTAMP_NTZ
{%- endmacro -%}

{%- macro sqlserver__type_timestamp() -%}
    DATETIME2
{%- endmacro -%}