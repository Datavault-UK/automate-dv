{%- macro alias(alias_config=none, prefix=none) -%}

    {{- adapter.dispatch('alias', 'dbtvault')(alias_config=alias_config, prefix=prefix) -}}

{%- endmacro %}

{%- macro default__alias(alias_config=none, prefix=none) -%}

{%- if alias_config is defined and alias_config is not none and alias_config -%}

    {%- if alias_config is mapping -%}

        {%- if alias_config['source_column'] and alias_config['alias'] -%}

            {%- if prefix -%}
                {{prefix}}.{{ alias_config['source_column'] }} AS {{ alias_config['alias'] }}
            {%- else -%}
                {{ alias_config['source_column'] }} AS {{ alias_config['alias'] }}
            {%- endif -%}

        {%- endif -%}

    {%- else -%}

        {%- if prefix -%}

        {{- dbtvault.prefix([alias_config], prefix) -}}

        {%- else -%}

        {{ alias_config }}

        {%- endif -%}

    {%- endif -%}

{%- else -%}

    {%- if execute -%}

        {{ exceptions.raise_compiler_error("Invalid alias configuration:\nexpected format: {source_column: 'column', alias: 'column_alias'}\ngot: " ~ alias_config) }}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}