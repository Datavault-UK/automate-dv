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

{%- macro add_columns(source_table, columns=[]) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}

    {%- if columns is mapping -%}

        {{ log('is a mapping', true) }}

        {#- Add aliases of provided pairs to excludes and full SQL to includes -#}
        {%- for col in columns -%}

            {%- if col | first == "!" -%}
                {%- set _ = include_columns.append("'" ~ col[1:] ~ "' AS " ~ columns[col]) -%}
                {%- set _ = exclude_columns.append(columns[col]) -%}
            {%- else -%}
                {%- set _ = include_columns.append(col ~ " AS " ~ columns[col]) -%}
                {%- set _ = exclude_columns.append(columns[col]) -%}
            {%- endif %}

        {%- endfor -%}

        {#- Print out all columns in includes -#}
        {%- for col in include_columns -%}
            {{ col -}}
            {%- if not loop.last -%}, {% endif -%}
        {%- endfor -%}

    {%- endif %}

{%- endmacro -%}