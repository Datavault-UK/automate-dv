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
    {%- if var('hash') | lower == 'md5' -%}
        BINARY(16)
    {%- elif var('hash') | lower == 'sha' -%}
        BINARY(32)
    {%- endif -%}
{%- endmacro -%}

{%- macro bigquery__type_binary() -%}
    STRING
{%- endmacro -%}


{%- macro type_string() -%}
  {{- return(adapter.dispatch('type_string', 'dbtvault')()) -}}
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
