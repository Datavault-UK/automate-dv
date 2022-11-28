{%- macro null_ghost(datatype, alias) -%}
    {{ adapter.dispatch('null_ghost', 'dbtvault')(datatype=datatype, alias=alias) }}
{%- endmacro -%}

{%- macro default__null_ghost(datatype, alias) -%}
    NULL AS {{alias}}
{%- endmacro -%}

{% macro bigquery__null_ghost(datatype, alias) -%}
    CAST(NULL AS {{datatype}}) AS {{alias}}
{%- endmacro -%}

{%- postgres__null_ghost(datatype, alias) -%}
    {{dbtvault.bigquery__null_ghost(datatype, alias) -%}}
{%- endmacro -%}

{%- sqlserver__null_ghost(datatype, alias) -%}
    {{dbtvault.bigquery__null_ghost(datatype, alias) -%}}
{%- endmacro -%}