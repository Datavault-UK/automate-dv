/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */


{% macro wrap_message(message, type='WARNING') %}

    {%- set new_message = [] -%}
    {%- set length_list = [] -%}

    {%- for ln in message.split('\n') -%}
        {%- do new_message.append((ln | trim)) -%}
        {%- do length_list.append((ln | length)) -%}
    {%- endfor -%}

    {%- set max_line_length = length_list | max -%}
    {%- set padding_length = (max_line_length - 7) // 2 -%}

    {%- set border = modules.itertools.repeat('=', padding_length) | join ('') ~ (type | upper) ~ modules.itertools.repeat('=', padding_length) | join ('') -%}

    {%- set wrapped_message = '\n' ~ border ~ '\n' ~ new_message | join('\n') ~ '\n' ~ border -%}

    {%- do return(wrapped_message) -%}

{% endmacro %}


{%- macro log_warning(message) -%}

    {%- set message = automate_dv.wrap_message(message) -%}

    {%- if execute and automate_dv.is_something(invocation_args_dict.get('which')) and invocation_args_dict.get('which') != 'compile' -%}
        {%- do exceptions.warn(message) -%}
    {%- endif -%}

{%- endmacro -%}


{%- macro log_error(message) -%}

    {%- set message = automate_dv.wrap_message(message, type='ERROR') -%}

    {%- if execute and automate_dv.is_something(invocation_args_dict.get('which')) and invocation_args_dict.get('which') != 'compile' -%}
        {%- do exceptions.raise_compiler_error(message) -%}
    {%- endif -%}

{%- endmacro -%}
