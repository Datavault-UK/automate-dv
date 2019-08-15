{% macro md5_binary_concat(columns, alias) %}

MD5_BINARY(CONCAT(

{% for column in columns[:-1] -%}

IFNULL(UPPER(TRIM(CAST({{column}} AS VARCHAR))), '^^'), '||',

{%- if loop.last -%}

IFNULL(UPPER(TRIM(CAST({{columns[-1]}} AS VARCHAR))), '^^')

{%- endif %}

{% endfor -%}

)) AS {{alias}}

{% endmacro %}