/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro repeat(str_to_repeat, desired_length=0) -%}

    {%- set ns = namespace(str_list=[]) %}

    {%- for i in range(desired_length) -%}
        {%- do ns.str_list.append(str_to_repeat) %}
    {%- endfor -%}

    {% do return(ns.str_list | join('')) %}

{%- endmacro -%}