/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro cast_date(column_str, as_string=false, datetime=false, alias=none, date_type=none) -%}
    {%- if datetime -%}
        {{- automate_dv.cast_datetime(column_str=column_str, as_string=as_string, alias=alias, date_type=date_type) -}}
    {%- else -%}
        {{ return(adapter.dispatch('cast_date', 'automate_dv')(column_str=column_str, as_string=as_string, alias=alias)) }}
    {%- endif -%}
{%- endmacro -%}

{%- macro snowflake__cast_date(column_str, as_string=false, alias=none) -%}

    {%- if not as_string -%}
        TO_DATE({{ column_str }})
    {%- else -%}
        TO_DATE('{{ column_str }}')
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}


{%- macro sqlserver__cast_date(column_str, as_string=false, alias=none) -%}

    {%- if not as_string -%}
        CONVERT(DATE, {{ column_str }})
    {%- else -%}
        CONVERT(DATE, '{{ column_str }}')
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}


{%- endmacro -%}


{%- macro bigquery__cast_date(column_str, as_string=false, alias=none) -%}

    {%- if not as_string -%}
        DATE({{ column_str }})
    {%- else -%}
        DATE('{{ column_str }}')
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}


{%- macro databricks__cast_date(column_str, as_string=false, alias=none) -%}

    {{ automate_dv.snowflake__cast_date(column_str=column_str, as_string=as_string, alias=alias)}}

{%- endmacro -%}


{%- macro postgres__cast_date(column_str, as_string=false, alias=none) -%}

    {%- if as_string -%}
    TO_DATE('{{ column_str }}', 'YYY-MM-DD')
    {%- else -%}
    TO_DATE({{ column_str }}::VARCHAR, 'YYY-MM-DD')
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}