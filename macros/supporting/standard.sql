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

{%- macro bigquery__standard(change_case='UPPER') -%}
    {%- if change_case == 'UPPER' -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS STRING))), '')
    {%- else -%}
        NULLIF(TRIM(CAST([EXPRESSION] AS STRING)), '')
    {%- endif -%}
{%- endmacro -%}

{%- macro sqlserver__standard(change_case='UPPER') -%}
    {%- if change_case == 'UPPER' -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS VARCHAR(max)))), '')
    {%- else -%}
        NULLIF(TRIM(CAST([EXPRESSION] AS VARCHAR(max))), '')
    {%- endif -%}
{%- endmacro -%}

{%- macro postgres__standard(change_case='UPPER') -%}
    {%- if change_case == 'UPPER' -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS VARCHAR))), '')
    {%- else -%}
        NULLIF(TRIM(CAST([EXPRESSION] AS VARCHAR)), '')
    {%- endif -%}
{%- endmacro -%}

{%- macro databricks__standard(change_case='UPPER') -%}
    {%- if change_case == 'UPPER' -%}
        NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS STRING))), '')
    {%- else -%}
        NULLIF(TRIM(CAST([EXPRESSION] AS STRING)), '')
    {%- endif -%}
{%- endmacro -%}