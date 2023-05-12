/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro standard_column_wrapper() -%}

    {%- set hash_content_casing = var('hash_content_casing', 'upper') -%}
    {%- set available_case_configs = ['upper', 'disabled'] -%}

    {%- if execute and (hash_content_casing | lower) not in available_case_configs  -%}
        {%- do exceptions.raise_compiler_error("Must provide a valid casing config for hash_content_casing.
                                                '{}' was provided. Can be one of {} (case insensitive)".format(
                                                                                hash_content_casing,
                                                                                available_case_configs | join(','))) -%}
    {%- endif -%}

    {{ return(adapter.dispatch('standard_column_wrapper', 'automate_dv')(hash_content_casing=hash_content_casing | lower)) }}
{%- endmacro %}


{%- macro default__standard_column_wrapper(hash_content_casing) -%}

    {%- if hash_content_casing == 'upper' -%}
        {%- set standardise -%}
            NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {{ automate_dv.type_string() }}))), '')
        {%- endset -%}
    {%- else -%}
        {%- set standardise -%}
            NULLIF(TRIM(CAST([EXPRESSION] AS {{ automate_dv.type_string() }})), '')
        {%- endset -%}
    {%- endif -%}

    {% do return(standardise) -%}

{%- endmacro -%}


{%- macro databricks__standard_column_wrapper(hash_content_casing) -%}

    {%- if hash_content_casing == 'upper' -%}
        {%- set standardise -%}
            NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {{ automate_dv.type_string(is_hash=true) }}))), '')
        {%- endset -%}
    {%- else -%}
        {%- set standardise -%}
            NULLIF(TRIM(CAST([EXPRESSION] AS {{ automate_dv.type_string(is_hash=true) }})), '')
        {%- endset -%}
    {%- endif -%}

    {% do return(standardise) -%}

{%- endmacro -%}


{%- macro sqlserver__standard_column_wrapper(hash_content_casing) -%}

    {%- if hash_content_casing == 'upper' -%}
        {%- set standardise -%}
            NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {{ automate_dv.type_string() }}(MAX)))), '')
        {%- endset -%}
    {%- else -%}
        {%- set standardise -%}
            NULLIF(TRIM(CAST([EXPRESSION] AS {{ automate_dv.type_string() }}(MAX))), '')
        {%- endset -%}
    {%- endif -%}

    {% do return(standardise) -%}

{%- endmacro -%}