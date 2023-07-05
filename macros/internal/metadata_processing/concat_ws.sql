/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro concat_ws(string_list, separator="||") -%}

    {{- adapter.dispatch('concat_ws', 'automate_dv')(string_list=string_list, separator=separator) -}}

{%- endmacro %}

{%- macro default__concat_ws(string_list, separator="||") -%}

CONCAT(
{%- for str in string_list %}
    {{ str }}
{%- if not loop.last %}, '{{ separator }}', {%- endif -%}
{%- endfor %}
)

{%- endmacro -%}

{%- macro bigquery__concat_ws(string_list, separator="||") -%}

    {{ automate_dv.default__concat_ws(string_list=string_list, separator=separator) }}

{%- endmacro -%}

{%- macro sqlserver__concat_ws(string_list, separator="||") -%}

    {{ automate_dv.default__concat_ws(string_list=string_list, separator=separator) }}

{%- endmacro -%}
