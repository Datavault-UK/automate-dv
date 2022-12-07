{%- macro type_timestamp() -%}
  {{- return(adapter.dispatch('type_timestamp', 'dbtvault')()) -}}
{%- endmacro -%}

{%- macro default__type_timestamp() -%}
    TIMESTAMP_NTZ
{%- endmacro -%}

{%- macro sqlserver__type_timestamp() -%}
    DATETIME2
{%- endmacro -%}