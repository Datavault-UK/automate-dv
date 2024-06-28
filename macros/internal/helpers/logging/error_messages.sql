/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */


{%- macro datepart_too_small_error(period) -%}

    {%- set message -%}
    This datepart ({{ period }}) is too small and not recommended, consider using a different datepart value (e.g. day) or rank column.
    'vault_insert_by_x' materialisations are intended for experimental or testing purposes only. They are not intended for use in production.

    Please see: https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset -%}

    {%- do automate_dv.log_error(message) -%}
{%- endmacro -%}


{%- macro datepart_not_recommended_warning(period) -%}

    {%- set message -%}
    This datepart ({{ period }}) is too small and not recommended, consider using a different datepart value (e.g. day) or rank column.
    'vault_insert_by_x' materialisations are intended for experimental or testing purposes only. They are not intended for use in production.

    Please see: https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset -%}

    {%- do automate_dv.log_warning(message) -%}
{%- endmacro -%}


{%- macro max_iterations_error() -%}

    {%- set message -%}
    Max iterations is 100,000. Consider using a different datepart value (e.g. day), rank column or loading data for a shorter time period.
    'vault_insert_by_x' materialisations are intended for experimental or testing purposes only. They are not intended for use in production.

    Please see: https://automate-dv.readthedocs.io/en/latest/materialisations/
    {%- endset %}

    {%- do automate_dv.log_warning(message) -%}
{%- endmacro -%}


{%- macro experimental_not_recommended_warning(func_name) -%}

    {%- set message -%}
    This functionality ({{ func_name }}) is intended for experimental or testing purposes only.
    Its behavior, reliability, and performance have not been thoroughly vetted for production environments.
    Using this functionality in a live production setting may result in unpredictable outcomes, data loss, or system instability.
    {%- endset -%}

    {%- do automate_dv.log_warning(message) -%}
{%- endmacro -%}


{%- macro currently_disabled_error(func_name) -%}

    {%- set message -%}
    This functionality ({{ func_name }}) is currently disabled for dbt-sqlserver 1.7.x,
    please revert to dbt-sqlserver 1.4.3 and AutomateDV 0.10.1 to use {{ func_name }}.

    This is due to a suspected bug with the SQLServer Adapter in the 1.7.x version.
    We are actively working to get this fixed. Thank you for your understanding.
    {%- endset -%}

    {%- do automate_dv.log_error(message) -%}
{%- endmacro -%}


{%- macro materialisation_deprecation_warning() -%}

    {%- set message -%}
        DEPRECATED: Since AutomateDV v0.11.0, vault_insert_by_x materialisations are now deprecated.
            These materialisation were initially designed to provide an option for rapid iterative development of
            incremental loading patterns in local environments for development and testing, allowing users to bypass
            the need for a comprehensive PSA or delta-loading solution. They are being deprecated to encourage the use
            of more robust solutions.
    {%- endset -%}

    {%- do automate_dv.log_warning(message) -%}
{%- endmacro -%}


{%- macro pit_bridge_deprecation_warning() -%}

    {%- set message -%}
        DEPRECATED: Since AutomateDV v0.11.0, the pit() and bridge() macros are now deprecated.
            This is because they are not currently fit-for-purpose and need significant usability
            and peformance improvements, as well as a design overhaul.
            Improved implementations will be released in a future version of AutomateDV.
    {%- endset -%}

    {%- do automate_dv.log_warning(message) -%}
{%- endmacro -%}
