/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro alias(alias_config=none, prefix=none) -%}

    {{- adapter.dispatch('alias', 'automate_dv')(alias_config=alias_config, prefix=prefix) -}}

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

        {{- automate_dv.prefix([alias_config], prefix) -}}

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