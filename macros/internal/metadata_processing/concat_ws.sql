/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro concat_ws(string_list, separator="||") -%}

    {{- adapter.dispatch('concat_ws', 'automate_dv')(string_list=string_list, separator=separator) -}}

{%- endmacro %}

{%- macro default__concat_ws(string_list, separator="||") -%}

CONCAT_WS('{{ separator }}',
{%- for str_obj in string_list %}
    {{ str_obj }}{% if not loop.last %},{% endif %}
{%- endfor %}
)

{%- endmacro -%}

{%- macro bigquery__concat_ws(string_list, separator="||") -%}

CONCAT(
{%- for str in string_list %}
    {{ str }}
{%- if not loop.last %}, '{{ separator }}', {%- endif -%}
{%- endfor %}
)

{%- endmacro -%}

{%- macro sqlserver__concat_ws(string_list, separator="||") -%}

    {{ automate_dv.default__concat_ws(string_list=string_list, separator=separator) }}

{%- endmacro -%}

 {%- macro postgres__concat_ws(string_list, separator="||") -%}

    {{ automate_dv.default__concat_ws(string_list=string_list, separator=separator) }}

{%- endmacro -%}

{%- macro databricks__concat_ws(string_list, separator="||") -%}

    {{ automate_dv.default__concat_ws(string_list=string_list, separator=separator) }}

{%- endmacro -%}
