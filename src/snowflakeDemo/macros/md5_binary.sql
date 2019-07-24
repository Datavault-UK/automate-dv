{% macro md5_binary(column, alias) %}

MD5_BINARY(UPPER(TRIM(CAST({{column}} AS VARCHAR)))) AS {{alias}}

{% endmacro %}