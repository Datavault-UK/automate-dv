{%- macro concat_ws(string_list, separator="||") -%}

    {{- adapter.dispatch('concat_ws', 'dbtvault')(string_list=string_list, separator=separator) -}}

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

    {{ dbtvault.default__concat_ws(string_list=string_list, separator=separator) }}

{%- endmacro -%}

{%- macro sqlserver__concat_ws(string_list, separator="||") -%}

    {{ dbtvault.default__concat_ws(string_list=string_list, separator=separator) }}

{%- endmacro -%}
