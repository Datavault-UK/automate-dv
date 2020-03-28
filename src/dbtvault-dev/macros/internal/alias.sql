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
{%- macro alias(column, prefix) -%}

{%- if column is iterable and column is not string -%}

    {%- if column['source_column'] and column['alias'] -%}

        {%- if prefix -%}
            {{prefix}}.{{ column['source_column'] }} AS {{ column['alias'] }}
        {%- else -%}
            {{ column['source_column'] }} AS {{ column['alias'] }}
        {%- endif -%}

    {%- else -%}

        {{ exceptions.raise_compiler_error("Invalid alias configuration:\nexpected format: {source_column: 'column', alias: 'column_alias'}\ngot: " ~ column) }}

    {%- endif -%}

{%- else -%}

    {%- if prefix -%}

    {{dbtvault.prefix([column], prefix) }}

    {%- else -%}

    {{ column }}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}