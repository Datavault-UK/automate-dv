{%- macro multikey(columns, prefix=none, condition=none, operator='AND') -%}

    {{- adapter.dispatch('multikey', packages = ['dbtvault'])(columns=columns, prefix=prefix, condition=condition, operator=operator) -}}

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
            {{ prefix[0] ~ '.' if prefix }}{{ col }} {{ condition }} {{ prefix[1] ~ '.' if prefix }}{{ col }}
            {%- if not loop.last %} {{ operator }} {% endif %}
        {% endfor -%}
    {%- else -%}
        {%- if columns is iterable and columns is not string -%}
            {%- for col in columns -%}
                {{ prefix[0] ~ '.' if prefix }}{{ col }} {{ condition if condition else '' }}
                {%- if not loop.last -%} {{ "\n    " ~ operator }} {% endif -%}
            {%- endfor -%}
        {%- else -%}
            {{ prefix[0] ~ '.' if prefix }}{{ columns }} {{ condition if condition else '' }}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}