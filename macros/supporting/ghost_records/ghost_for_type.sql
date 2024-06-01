/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro ghost_for_type(col_type, col_name) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set binary_types = [automate_dv.type_binary(for_dbt_compare=true)] | map('lower') | list -%}
{%- set string_types = [dbt.type_string() | lower, 'varchar', 'character varying', 'char', 'string',
                        'text', 'ntext', 'nvarchar', 'nchar'] -%}
{%- set time_types = [dbt.type_timestamp() | lower, 'date', 'datetime', 'datetime2', 'timestamp',
                      'timestamp_ltz', 'timestamp_ntz', 'timestamp_tz', 'timestamp with time zone',
                      'timestamp without time zone', 'datetimeoffset', 'smalldatetime', 'time',
                      'time with timezone'] -%}

{%- if col_type in binary_types -%}
    {%- do return(automate_dv.binary_ghost(alias=col_name, hash=hash)) -%}
{%- elif col_type in string_types -%}
    {%- do return(automate_dv.null_ghost(data_type=col_type, alias=col_name)) -%}
{%- elif col_type in time_types -%}
    {%- do return(automate_dv.date_ghost(date_type=col_type, alias=col_name)) -%}
{%- else -%}
    {%- do return(automate_dv.null_ghost(data_type=col_type, alias=col_name)) -%}
{%- endif -%}

{% endmacro %}
