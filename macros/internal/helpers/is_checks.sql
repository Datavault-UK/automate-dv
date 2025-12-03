/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro is_list(obj, empty_is_false=false) -%}
    {%- do log('IS_LIST 1: ' ~ obj, true) -%}
    {%- if obj is undefined -%}
        {%- do log('IS_LIST 2: ' ~ obj, true) -%}
        {%- do return(false) -%}
    {%- elif obj is iterable and obj is not string and obj is not mapping -%}
        {%- if empty_is_false and (obj is none or not obj) -%}
            {%- do log('IS_LIST 3: ' ~ obj, true) -%}
            {%- do return(false) -%}
        {%- else -%}
            {%- do log('IS_LIST 4: ' ~ obj, true) -%}
            {%- do return(true) -%}
        {%- endif -%}
    {%- else -%}
        {%- do log('IS_LIST 5: ' ~ obj, true) -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}



{%- macro is_nothing(obj) -%}

    {%- if (obj is none) or (obj is not defined) or (not obj) or automate_dv.is_list(obj, empty_is_false=true) -%}
        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}



{%- macro is_something(obj) -%}
    {%- do log('IS_SOMETHING 1: ' ~ obj, true) -%}
    {%- if obj is not none and obj is defined and obj -%}
        {#- if an empty list, do not consider the object something -#}
        {% if automate_dv.is_list(obj, empty_is_false=true) %}
            {%- do log('IS_SOMETHING 2: ' ~ obj, true) -%}
            {%- do return(true) -%}
        {%- else -%}
            {%- do log('IS_SOMETHING 3: ' ~ obj, true) -%}
            {%- do return(false) -%}
        {%- endif -%}
    {%- else -%}
        {%- do log('IS_SOMETHING 4: ' ~ obj, true) -%}
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
