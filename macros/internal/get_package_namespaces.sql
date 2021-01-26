{%- macro get_dbtvault_namespaces() -%}
    {%- set override_namespaces = var('adapter_packages', []) -%}
    {%- do return(override_namespaces + ['dbtvault']) -%}
{%- endmacro -%}