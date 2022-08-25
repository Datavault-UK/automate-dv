{%- macro type_timestamp() -%}
  {{- return(adapter.dispatch('type_timestamp', 'dbtvault')()) -}}
{%- endmacro -%}

{%- macro default__type_timestamp() -%}
    TIMESTAMP_NTZ
{%- endmacro -%}

{%- macro sqlserver__type_timestamp() -%}
    DATETIME2
{%- endmacro -%}



{%- macro type_binary() -%}
  {{- return(adapter.dispatch('type_binary', 'dbtvault')()) -}}
{%- endmacro -%}

{%- macro default__type_binary() -%}
    {%- if var('hash') == 'MD5' -%}
    BINARY(16)
    {%- elif var('hash') == 'SHA' -%}
    BINARY(32)
    {%- endif -%}
{%- endmacro -%}
