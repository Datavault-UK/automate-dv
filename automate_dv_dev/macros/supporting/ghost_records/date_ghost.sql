/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro date_ghost(date_type, alias) -%}
    {{ adapter.dispatch('date_ghost', 'automate_dv')(date_type=date_type, alias=alias) }}
{%- endmacro -%}

{%- macro default__date_ghost(date_type, alias=none) -%}

        {%- if date_type == 'date' -%}
            {{ automate_dv.cast_date('1900-01-01', as_string=true, datetime=false, alias=alias) }}
        {%- else -%}
            {{ automate_dv.cast_date('1900-01-01 00:00:00', as_string=true, datetime=true, alias=alias, date_type=date_type) }}
        {%- endif -%}

{%- endmacro -%}


{%- macro postgres__date_ghost(date_type, alias=none) -%}

    {%- if date_type == 'date' -%}
        {{ automate_dv.cast_date('1900-01-01', as_string=true, datetime=false, alias=alias) }}
    {%- else -%}
        to_char(timestamp '1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp {%- if alias %} AS {{alias}}{%- endif -%}
    {%- endif -%}

{%- endmacro -%}
