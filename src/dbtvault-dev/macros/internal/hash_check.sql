{%- macro hash_check(hash) -%}

{% if hash == 'MD5' %}
MD5_BINARY('^^')
{% elif hash == 'SHA' %}
SHA2_BINARY('^^')
{% else %}
MD5_BINARY('^^')
{% endif %}

{% endmacro %}