/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro null_ghost(datatype, alias) -%}
    {{ adapter.dispatch('null_ghost', 'automate_dv')(datatype=datatype, alias=alias) }}
{%- endmacro -%}

{%- macro default__null_ghost(datatype, alias) -%}
    NULL AS {{alias}}
{%- endmacro -%}

{% macro bigquery__null_ghost(datatype, alias) -%}
    CAST(NULL AS {{datatype}}) AS {{alias}}
{%- endmacro -%}

{%- macro postgres__null_ghost(datatype, alias) -%}
    {{ automate_dv.bigquery__null_ghost(datatype, alias) }}
{%- endmacro -%}

{%- macro sqlserver__null_ghost(datatype, alias) -%}
    {{ automate_dv.bigquery__null_ghost(datatype, alias) }}
{%- endmacro -%}