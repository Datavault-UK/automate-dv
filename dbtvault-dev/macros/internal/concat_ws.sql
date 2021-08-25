{%- macro concat_ws(string_list, separator) -%}

{{- 'CONCAT(' -}}
{%- for str in string_list -%}
    {{- "{}".format(str) -}}
    {{- ",'{}',".format(separator) if not loop.last -}}
{%- endfor -%}
{{- '\n)' -}}

{%- endmacro -%}