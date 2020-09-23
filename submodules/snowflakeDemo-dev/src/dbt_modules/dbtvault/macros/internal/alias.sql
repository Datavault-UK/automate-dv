{#- Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}
{%- macro alias(alias_config=none, prefix=none) -%}

    {{- adapter_macro('dbtvault.alias', alias_config=alias_config, prefix=prefix) -}}

{%- endmacro %}

{%- macro default__alias(alias_config=none, prefix=none) -%}

{%- if alias_config -%}

    {%- if alias_config is iterable and alias_config is not string -%}

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