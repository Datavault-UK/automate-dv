/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro cast_datetime(column_str, as_string=false, alias=none, date_type=none) -%}

    {%- if as_string -%}
        {%- set column_str -%} '{{ column_str }}' {%- endset -%}
    {%- endif -%}

    {%- set date_type = date_type | lower -%}

    {{ return(adapter.dispatch('cast_datetime', 'automate_dv')(column_str=column_str, as_string=as_string, alias=alias, date_type=date_type)) }}
{%- endmacro -%}

{%- macro snowflake__cast_datetime(column_str, as_string=false, alias=none, date_type=none) -%}

    {%- if date_type == 'timestamp_tz' -%}
        TO_TIMESTAMP_TZ({{ column_str }})
    {%- elif date_type == 'timestamp_ltz' -%}
        TO_TIMESTAMP_LTZ({{ column_str }})
    {%- elif date_type == 'timestamp_ntz' -%}
        TO_TIMESTAMP_NTZ({{ column_str }})
    {%- else -%}
        TO_TIMESTAMP({{ column_str }})
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}


{%- macro sqlserver__cast_datetime(column_str, as_string=false, alias=none, date_type=none) -%}

    CONVERT(DATETIME2, {{ column_str }})

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}


{%- macro bigquery__cast_datetime(column_str, as_string=false, alias=none, date_type=none) -%}

    {%- if date_type == 'timestamp' -%}
        PARSE_TIMESTAMP('%F %H:%M:%E6S', {{ column_str }})
    {%- else -%}
        PARSE_DATETIME('%F %H:%M:%E6S', {{ column_str }})
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}


{%- macro databricks__cast_datetime(column_str, as_string=false, alias=none, date_type=none) -%}

    {{ automate_dv.snowflake__cast_datetime(column_str=column_str, as_string=as_string, alias=alias, date_type=date_type)}}

{%- endmacro -%}


{%- macro postgres__cast_datetime(column_str, as_string=false, alias=none, date_type=none) -%}

    to_char(timestamp {{ column_str }}, 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp

    {%- if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}