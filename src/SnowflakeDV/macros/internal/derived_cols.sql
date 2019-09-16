{%- macro derived_cols(pairs) -%}
{% for pair in pairs -%}

    {{ snow_vault.create_col(pair[0], pair[1]) }}
    {%- if not loop.last -%} , {% endif %}
{% endfor %}

{%- endmacro -%}
