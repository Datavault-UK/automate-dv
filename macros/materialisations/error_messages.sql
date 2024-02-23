/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */


{% macro wrap_warning(warning_message) %}

    {%- set new_message = [] -%}
    {%- set length_list = [] -%}

    {%- for ln in warning_message.split('\n') -%}
        {%- do new_message.append((ln | trim)) -%}
        {%- do length_list.append((ln | length)) -%}
    {%- endfor -%}

    {%- set max_line_length = length_list | max -%}
    {%- set padding_length = (max_line_length - 7) // 2 -%}

    {%- set border = modules.itertools.repeat('=', padding_length) | join ('') ~ 'WARNING' ~ modules.itertools.repeat('=', padding_length) | join ('') -%}

    {%- set wrapped_message = '\n' ~ border ~ '\n' ~ new_message | join('\n') ~ '\n' ~ border -%}

    {%- do return(wrapped_message) -%}

{% endmacro %}


{%- macro datepart_too_small_error(period) -%}

    {%- set message -%}
    This datepart ({{ period }}) is too small and not recommended, consider using a different datepart value (e.g. day) or rank column.
    'vault_insert_by_x' materialisations are intended for experimental or testing purposes only. They are not intended for use in production.

    Please see: https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset -%}

    {%- if execute -%}
    {{- exceptions.raise_compiler_error(message) -}}
    {%- endif -%}

{%- endmacro -%}


{%- macro datepart_not_recommended_warning(period) -%}

    {%- set message -%}
    This datepart ({{ period }}) is too small and not recommended, consider using a different datepart value (e.g. day) or rank column.
    'vault_insert_by_x' materialisations are intended for experimental or testing purposes only. They are not intended for use in production.

    Please see: https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset -%}

    {%- if execute -%}
    {{- exceptions.warn(automate_dv.wrap_warning(message)) -}}
    {%- endif -%}

{%- endmacro -%}


{%- macro max_iterations_error() -%}

    {%- set message -%}
    Max iterations is 100,000. Consider using a different datepart value (e.g. day), rank column or loading data for a shorter time period.
    'vault_insert_by_x' materialisations are intended for experimental or testing purposes only. They are not intended for use in production.

    Please see: https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset %}

    {%- if execute -%}
    {{- exceptions.raise_compiler_error(message) -}}
    {%- endif -%}

{%- endmacro -%}


{%- macro experimental_not_recommended_warning(func_name) -%}

    {%- set message -%}
    This functionality ({{ func_name }}) is intended for experimental or testing purposes only.
    Its behavior, reliability, and performance have not been thoroughly vetted for production environments.
    Using this functionality in a live production setting may result in unpredictable outcomes, data loss, or system instability.
    {%- endset -%}

    {%- if execute -%}
    {{- exceptions.warn(automate_dv.wrap_warning(message)) -}}
    {%- endif -%}

{%- endmacro -%}


{%- macro currently_disabled_error(func_name) -%}

    {%- set message -%}
    This functionality ({{ func_name }}) is currently disabled for dbt-sqlserver 1.7.x,
    please revert to dbt-sqlserver 1.4.3 and AutomateDV 0.10.1 to use {{ func_name }}.

    This is due to a suspected bug with the SQLServer Adapter in the 1.7.x version.
    We are actively working to get this fixed. Thank you for your understanding.
    {%- endset -%}

    {%- if execute -%}
    {{- exceptions.raise_compiler_error(automate_dv.wrap_warning(message)) -}}
    {%- endif -%}

{%- endmacro -%}
