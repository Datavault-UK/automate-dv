/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro null_ghost(data_type, alias) -%}
    {{ adapter.dispatch('null_ghost', 'automate_dv')(data_type=data_type, alias=alias) }}
{%- endmacro -%}

{%- macro default__null_ghost(data_type, alias) -%}
    NULL AS {{alias}}
{%- endmacro -%}

{% macro bigquery__null_ghost(data_type, alias) -%}
    CAST(NULL AS {{data_type}}) AS {{alias}}
{%- endmacro -%}

{%- macro postgres__null_ghost(data_type, alias) -%}
    {{ automate_dv.bigquery__null_ghost(data_type, alias) }}
{%- endmacro -%}

{%- macro sqlserver__null_ghost(data_type, alias) -%}
    {{ automate_dv.bigquery__null_ghost(data_type, alias) }}
{%- endmacro -%}