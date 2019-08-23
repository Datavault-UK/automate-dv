{% macro md5_binary(columns, alias) %}

{% if columns is string %}

MD5_BINARY(UPPER(TRIM(CAST({{columns}} AS VARCHAR)))) AS {{alias}}

{%- else -%}

MD5_BINARY(CONCAT(

{% for column in columns[:-1] -%}

IFNULL(UPPER(TRIM(CAST({{column}} AS VARCHAR))), '^^'), '||',

{%- if loop.last -%}

IFNULL(UPPER(TRIM(CAST({{columns[-1]}} AS VARCHAR))), '^^') )) AS {{alias}}

{% endif %}
{% endfor -%}
{% endif %}
{% endmacro %}

