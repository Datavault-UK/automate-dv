{%- macro alias_all(columns=none, prefix=none) -%}

    {{- adapter.dispatch('alias_all', 'dbtvault')(columns=columns, prefix=prefix) -}}

{%- endmacro %}

{%- macro default__alias_all(columns, prefix) -%}

{%- if dbtvault.is_list(columns) -%}

    {%- for column in columns -%}
        {{ dbtvault.alias(alias_config=column, prefix=prefix) }}
        {%- if not loop.last -%} , {% endif -%}
    {%- endfor -%}

{%- elif columns is string -%}

{{ dbtvault.alias(alias_config=columns, prefix=prefix) }}

{%- else -%}

    {%- if execute -%}
        {{ exceptions.raise_compiler_error("Invalid columns object provided. Must be a list or a string.") }}
    {%- endif %}

{%- endif %}

{%- endmacro -%}