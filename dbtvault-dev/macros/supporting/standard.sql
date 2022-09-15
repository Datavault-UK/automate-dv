{%- macro standard(change_case='UPPER') -%}
    {{- return(adapter.dispatch('standard', 'dbtvault')(change_case=change_case)) -}}
{%- endmacro -%}

{%- macro default__standard(change_case='UPPER') -%}
    {%- if change_case == 'UPPER' -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS VARCHAR))), '')
    {%- else -%}
        NULLIF(TRIM(CAST([EXPRESSION] AS VARCHAR)), '')
    {%- endif -%}
{%- endmacro -%}