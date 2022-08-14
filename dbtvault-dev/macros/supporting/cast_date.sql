{%- macro cast_date(column_str, as_string=false, datetime=false, alias=none) -%}
    {{ return(adapter.dispatch('cast_date', 'dbtvault')(column_str=column_str, as_string=as_string, datetime=datetime, alias=alias)) }}
{%- endmacro -%}

{%- macro sqlserver__cast_date(column_str, as_string=false, datetime=false, alias=none) -%}

    {%- if datetime -%}
        {%- if not as_string -%}
            CONVERT(DATETIME2, {{ column_str }})
        {%- else -%}
            CONVERT(DATETIME2, '{{ column_str }}')
        {%- endif -%}
    {%- else -%}
        {%- if not as_string -%}
            CONVERT(DATE, {{ column_str }})
        {%- else -%}
            CONVERT(DATE, '{{ column_str }}')
        {%- endif -%}
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}


{%- endmacro -%}

{%- macro snowflake__cast_date(column_str, as_string=false, datetime=false, alias=none) -%}

    {%- if datetime -%}
        {%- if not as_string -%}
            TO_DATETIME({{ column_str }})
        {%- else -%}
            TO_DATETIME('{{ column_str }}')
        {%- endif -%}
    {%- else -%}
        {%- if not as_string -%}
            TO_DATE({{ column_str }})
        {%- else -%}
            TO_DATE('{{ column_str }}')
        {%- endif -%}
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}

{%- macro bigquery__cast_date(column_str, as_string=false, datetime=false, alias=none) -%}

    {%- if datetime -%}
        {%- if not as_string -%}
            CAST(PARSE_DATETIME('%F %H:%M:%E6S', {{ column_str }}))
        {%- else -%}
            CAST(PARSE_DATETIME('%F %H:%M:%E6S', '{{ column_str }}'))
        {%- endif -%}
    {%- else -%}
        {%- if not as_string -%}
            DATE({{ column_str }})
        {%- else -%}
            DATE('{{ column_str }}')
        {%- endif -%}
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}
