/*
 *  Copyright (c) Business Thinking Ltd. 2019-2022
 *  This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro cast_date(column_str, as_string=false, datetime=false, alias=none) -%}
    {{ return(adapter.dispatch('cast_date', 'dbtvault')(column_str=column_str, as_string=as_string, datetime=datetime, alias=alias)) }}
{%- endmacro -%}

{%- macro snowflake__cast_date(column_str, as_string=false, datetime=false, alias=none) -%}

    {%- if datetime -%}
        {%- if not as_string -%}
            TO_TIMESTAMP({{ column_str }})
        {%- else -%}
            TO_TIMESTAMP('{{ column_str }}')
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


{%- macro bigquery__cast_date(column_str, as_string=false, datetime=false, alias=none) -%}

    {%- if datetime -%}

        {%- if not as_string -%}
            PARSE_DATETIME('%F %H:%M:%E6S', {{ column_str }})
        {%- else -%}
            PARSE_DATETIME('%F %H:%M:%E6S', '{{ column_str }}')
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


{%- macro databricks__cast_date(column_str, as_string=false, datetime=false, alias=none) -%}

    {{ dbtvault.snowflake__cast_date(column_str=column_str, as_string=as_string, datetime=datetime, alias=alias)}}

{%- endmacro -%}


{%- macro postgres__cast_date(column_str, as_string=false, datetime=false, alias=none) -%}

{%- if datetime -%}
        {%- if not as_string -%}
            TO_TIMESTAMP({{ column_str }})
        {%- else -%}
            TO_TIMESTAMP('{{ column_str }}', 'YYY-MM-DD HH24:MI:SS.MS')
        {%- endif -%}
    {%- else -%}
        {%- if not as_string -%}
            TO_DATE({{ column_str }})
        {%- else -%}
            TO_DATE('{{ column_str }}', 'YYY-MM-DD')
        {%- endif -%}
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}