{%- macro gen_hashing(pairs) -%}

SELECT
{% for pair in pairs -%}

    {{ dbtvault.md5_binary(pair[0], pair[1]) }}
    {%- if not loop.last -%} , {% endif %}
{% endfor %}

{%- endmacro -%}
