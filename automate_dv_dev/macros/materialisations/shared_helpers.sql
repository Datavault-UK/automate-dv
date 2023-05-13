/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro check_placeholder(model_sql, placeholder='__PERIOD_FILTER__') -%}

    {%- if model_sql.find(placeholder) == -1 -%}
    {%- set error_message -%}
    Model '{{ model.unique_id }}' does not include the required string '{{ placeholder }}' in its sql
        {%- endset -%}
        {{- exceptions.raise_compiler_error(error_message) -}}
    {%- endif -%}

{%- endmacro -%}