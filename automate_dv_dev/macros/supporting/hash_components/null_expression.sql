/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro null_expression(column_str) -%}

    {%- if execute and not column_str -%}
        {%- do exceptions.raise_compiler_error("Must provide a column_str argument to null expression macro!") -%}
    {%- endif -%}

    {%- set null_placeholder_string = var('null_placeholder_string', '^^') -%}
    {%- set standardise = automate_dv.standard_column_wrapper() %}

    {{ return(adapter.dispatch('null_expression', 'automate_dv')(standardise=standardise, column_str=column_str, null_placeholder_string=null_placeholder_string)) }}
{%- endmacro %}


{%- macro default__null_expression(standardise, column_str, null_placeholder_string) -%}

    {%- set column_expression -%}
        IFNULL({{ standardise | replace('[EXPRESSION]', column_str) }}, '{{ null_placeholder_string}}')
    {%- endset -%}

    {% do return(column_expression) %}

{%- endmacro -%}


{%- macro postgres__null_expression(standardise, column_str, null_placeholder_string) -%}

    {%- set column_expression -%}
        COALESCE({{ standardise | replace('[EXPRESSION]', column_str) }}, '{{ null_placeholder_string }}')
    {%- endset -%}

    {% do return(column_expression) %}

{%- endmacro -%}

{%- macro sqlserver__null_expression(standardise, column_str, null_placeholder_string) -%}

    {%- set column_expression -%}
        ISNULL({{ standardise | replace('[EXPRESSION]', column_str) }}, '{{ null_placeholder_string }}')
    {%- endset -%}

    {% do return(column_expression) %}

{%- endmacro -%}