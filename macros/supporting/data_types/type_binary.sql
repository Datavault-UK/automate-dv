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

{%- macro postgres__type_binary() -%}
    VARCHAR
{%- endmacro -%}