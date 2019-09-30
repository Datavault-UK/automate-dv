{%- macro add_columns(pairs) -%}
{% for pair in pairs -%}

    {{ dbtvault.create_col(pair[0], pair[1]) }}
    {%- if not loop.last -%} , {% endif %}
{% endfor %}

{%- endmacro -%}
