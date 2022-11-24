{%- macro standard_column_wrapper() -%}
    {{ return(adapter.dispatch('standard_column_wrapper', 'dbtvault')()) }}
{%- endmacro %}


{%- macro default__standard_column_wrapper() -%}

    {%- set standardise = "NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {}))), '')".format(dbtvault.type_string()) %}

    {% do return(standardise) -%}

{%- endmacro -%}