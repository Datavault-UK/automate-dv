/*
 * Copyright (c) Business Thinking Ltd. 2019-2026
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro type_string() -%}
  {{- return(adapter.dispatch('type_string', 'automate_dv')()) -}}
{%- endmacro -%}

{%- macro default__type_string() -%}
    VARCHAR
{%- endmacro -%}

{%- macro bigquery__type_string() -%}
    STRING
{%- endmacro -%}

{%- macro sqlserver__type_string() -%}
    VARCHAR
{%- endmacro -%}

{%- macro databricks__type_string() -%}
    STRING
{%- endmacro -%}

{%- macro redshift__type_string() -%}
    VARCHAR
{%- endmacro -%}
