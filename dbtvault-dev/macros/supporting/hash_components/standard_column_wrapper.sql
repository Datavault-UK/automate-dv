{%- macro standard_column_wrapper() -%}
    {{ return(adapter.dispatch('standard_column_wrapper', 'dbtvault')()) }}
{%- endmacro %}


{%- macro default__standard_column_wrapper() -%}

    {%- set standardise -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {{ dbtvault.type_string() }}))), '')
    {%- endset -%}

    {% do return(standardise) -%}

{%- endmacro -%}

{%- macro databricks__standard_column_wrapper() -%}

    {%- set standardise -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {{ dbtvault.type_string(is_hash=true) }}))), '')
    {%- endset -%}

    {% do return(standardise) -%}

{%- endmacro -%}

{%- macro sqlserver__standard_column_wrapper() -%}

    {%- set standardise -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {{ dbtvault.type_string() }}(MAX)))), '')
    {%- endset -%}

    {% do return(standardise) -%}

{%- endmacro -%}