/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro repeat(str_to_repeat, desired_length=0) -%}

    {% do return(str_to_repeat * desired_length) %}

{%- endmacro -%}