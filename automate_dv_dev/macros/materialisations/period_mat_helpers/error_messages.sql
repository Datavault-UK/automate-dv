/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro sqlserver_datepart_too_small_error(period) -%}

    {%- set error_message -%}
    This datepart ({{ period }}) is too small and cannot be used for this purpose in MS SQL Server, consider using a different datepart value (e.g. day).
    vault_insert_by materialisations are not intended for this purpose, please see https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset -%}

    {{- exceptions.raise_compiler_error(error_message) -}}

{%- endmacro -%}

{%- macro sqlserver_max_iterations_error() -%}

    {%- set error_message -%}
    Max iterations is 100,000. Consider using a different datepart value (e.g. day) or loading data for a shorter time period.
    vault_insert_by materialisations are not intended for this purpose, please see https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset -%}

    {{- exceptions.raise_compiler_error(error_message) -}}

{%- endmacro -%}