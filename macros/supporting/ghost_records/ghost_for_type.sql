/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro ghost_for_type(col_type, col_name) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set binary_types = [automate_dv.type_binary(for_dbt_compare=true)] | map('lower') | list -%}
{%- set string_types = [dbt.type_string() | lower, 'varchar'] -%}
{%- set time_types = ['date', dbt.type_timestamp(), 'timestamp', 'timestampntz'] -%}

{{ print('----------------') }}
{{ print('col_type: ' ~ col_type) }}
{{ print('binary_types: ' ~ binary_types) }}
{{ print('string_types: ' ~ string_types) }}
{{ print('time_types: ' ~ time_types) }}

{%- if col_type in string_types -%}
    {{ print('string_types selected.') }}
    {% do return(automate_dv.null_ghost(col_type, col_name)) -%}
{%- endif -%}

{%- if col_type in binary_types -%}
    {{ print('binary_types selected.') }}
    {%- do return(automate_dv.binary_ghost(alias=col_name, hash=hash)) -%}
{%- endif -%}

{%- if col_type in time_types -%}
    {{ print('time_types selected.') }}
    {%- do return(automate_dv.date_ghost(date_type=col_type, alias=col_name)) -%}
{%- endif -%}


{% endmacro %}
