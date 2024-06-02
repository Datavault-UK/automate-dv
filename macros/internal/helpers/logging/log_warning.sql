/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro log_warning(message) -%}

    {%- if automate_dv.is_something(invocation_args_dict.get('which')) and invocation_args_dict.get('which') != 'compile' -%}
        {%- do exceptions.warn(message) -%}
    {%- endif -%}

{%- endmacro -%}