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
