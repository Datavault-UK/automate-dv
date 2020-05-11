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
{%- macro alias(source_column='', prefix='') -%}

{%- if (source_column is defined and source_column) -%}

    {%- if source_column is iterable and source_column is not string -%}

        {%- if source_column['source_column'] and source_column['alias'] -%}

            {%- if prefix -%}
                {{prefix}}.{{ source_column['source_column'] }} AS {{ source_column['alias'] }}
            {%- else -%}
                {{ source_column['source_column'] }} AS {{ source_column['alias'] }}
            {%- endif -%}

        {%- endif -%}

    {%- else -%}

        {%- if prefix -%}

        {{- dbtvault.prefix([source_column], prefix) -}}

        {%- else -%}

        {{ source_column }}

        {%- endif -%}

    {%- endif -%}

{%- else -%}

    {%- if execute -%}

        {{ exceptions.raise_compiler_error("Invalid alias configuration:\nexpected format: {source_column: 'column', alias: 'column_alias'}\ngot: " ~ source_column) }}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}