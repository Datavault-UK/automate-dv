{%- macro multikey(columns, prefix=none, condition=none, operator='AND') -%}

    {{- adapter.dispatch('multikey', packages = dbtvault.get_dbtvault_namespaces())(columns=columns, prefix=prefix, condition=condition, operator=operator) -}}

{%- endmacro %}

{%- macro default__multikey(columns, prefix=none, condition=none, operator='AND') -%}

    {%- if prefix is string -%}
        {%- set prefix = [prefix] -%}
    {%- endif -%}

    {%- if columns is string -%}
        {%- set columns = [columns] -%}
    {%- endif -%}

    {%- if condition in ['<>', '!=', '='] -%}
        {%- for col in columns -%}
            {%- if prefix -%}
            {{ dbtvault.prefix([col], prefix[0], alias_target='target') }} {{ condition }} {{ dbtvault.prefix([col], prefix[1]) }}
            {%- endif %}
            {%- if not loop.last %} {{ operator }} {% endif %}
        {% endfor -%}
    {%- else -%}
        {%- if dbtvault.is_list(columns) -%}
            {%- for col in columns -%}
                {{ dbtvault.prefix([col], prefix[0]) }}
                {%- if not loop.last -%} {{ "\n    " ~ operator }} {% endif -%}
            {%- endfor -%}
        {%- else -%}
            {{ dbtvault.prefix([columns], prefix[0]) }}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}