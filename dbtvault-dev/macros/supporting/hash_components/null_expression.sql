{%- macro null_expression(column_str=column_str) -%}

    {%- set null_placeholder_string = var('null_placeholder_string', '^^') -%}
    {%- set standardise = dbtvault.standard_column_wrapper() %}

    {{ return(adapter.dispatch('null_expression', 'dbtvault')(standardise=standardise, column_str=column_str, null_placeholder_string=null_placeholder_string)) }}
{%- endmacro %}


{%- macro default__null_expression(standardise=standardise, column_str=column_str, null_placeholder_string=null_placeholder_string) -%}

    {%- set column_expression -%}
        IFNULL({{ standardise | replace('[EXPRESSION]', column_str) }}, '{{ null_placeholder_string}}')
    {%- endset -%}

    {% do return(column_expression) %}

{%- endmacro -%}


{%- macro postgres__null_expression(standardise=standardise, column_str=column_str, null_placeholder_string=null_placeholder_string) -%}

    {%- set column_expression -%}
        COALESCE({{ standardise | replace('[EXPRESSION]', column_str) }}, '{{ null_placeholder_string }}')
    {%- endset -%}

    {% do return(column_expression) %}

{%- endmacro -%}

{%- macro sqlserver__null_expression(standardise=standardise, column_str=column_str, null_placeholder_string=null_placeholder_string) -%}

    {%- set column_expression -%}
        ISNULL({{ standardise | replace('[EXPRESSION]', column_str) }}, '{{ null_placeholder_string }}')
    {%- endset -%}

    {% do return(column_expression) %}

{%- endmacro -%}