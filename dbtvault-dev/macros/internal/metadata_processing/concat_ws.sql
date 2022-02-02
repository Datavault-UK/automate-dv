{%- macro concat_ws(string_list, separator="||") -%}

    {{- adapter.dispatch('concat_ws', 'dbtvault')(string_list=string_list, separator=separator) -}}

{%- endmacro %}

{%- macro default__concat_ws(string_list, separator="||") -%}

    {{  "CONCAT_WS('" ~ separator ~ "', " ~ string_list | join(", ") ~ ")" }}

{%- endmacro -%}

{%- macro bigquery__concat_ws(string_list, separator="||") -%}

    {{- 'CONCAT(' -}}
    {%- for str in string_list -%}
        {{- "{}".format(str) -}}
        {{- ",'{}',".format(separator) if not loop.last -}}
    {%- endfor -%}
    {{- '\n)' -}}

{%- endmacro -%}