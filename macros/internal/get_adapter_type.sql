{%- macro get_adapter_type() -%}

    {%- set macro = adapter.dispatch('get_adapter_type', 'dbtvault')() -%}

    {%- do return(macro) -%}

{%- endmacro %}

{%- macro default__get_adapter_type() -%}

    {%- do return("snowflake") -%}

{%- endmacro -%}

{%- macro sqlserver__get_adapter_type() -%}

    {%- do return("sqlserver") -%}

{%- endmacro -%}

{%- macro bigquery__get_adapter_type() -%}

    {%- do return("bigquery") -%}

{%- endmacro -%}
