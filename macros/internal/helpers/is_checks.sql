/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro is_list(obj, empty_is_false=false) -%}
    {%- if obj is not defined -%}
        {%- do return(false) -%}

    {%- elif obj is iterable and obj is not string and obj is not mapping -%}

        {%- if empty_is_false and (obj | length == 0) -%}
            {%- do return(false) -%}
        {%- else -%}
            {%- do return(true) -%}
        {%- endif -%}

    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}
{%- endmacro -%}



{%- macro is_nothing(obj) -%}

    {%- if obj is not defined or not obj -%}
        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}



{%- macro is_something(obj) -%}
    {%- if obj is defined and obj -%}
        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}
{%- endmacro -%}



{%- macro is_expression(obj) -%}

    {%- if obj is string -%}
        {%- if (obj | first == "'" and obj | last == "'") or ("(" in obj and ")" in obj) or "::" in obj -%}
            {%- do return(true) -%}
        {%- else -%}
            {%- do return(false) -%}
        {%- endif -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}
