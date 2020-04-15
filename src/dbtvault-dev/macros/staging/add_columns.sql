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

{%- macro add_columns(source, pairs=[]) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}

{%- if source is defined and source is not none -%}
{%- set cols = adapter.get_columns_in_relation(source) -%}
{%- endif %}

{#- Add aliases of provided pairs to excludes and full SQL to includes -#}
{%- for pair in pairs -%}
    {%- if pair[0] | first == "!" -%}
        {%- set _ = include_columns.append("'" ~ pair[0][1:] ~ "' AS " ~ pair[1]) -%}
        {%- set _ = exclude_columns.append(pair[1]) -%}
    {%- else -%}
        {%- set _ = include_columns.append(pair[0] ~ " AS " ~ pair[1]) -%}
        {%- set _ = exclude_columns.append(pair[1]) -%}
    {%- endif %}
{%- endfor -%}

{%- if source is defined and source is not none -%}
{#- Add all columns from source table -#}
{%- for col in cols -%}
    {%- if col.column not in exclude_columns -%}
        {%- set _ = include_columns.append(col.column) -%}
    {%- endif -%}
{%- endfor -%}
{%- endif %}

{#- Print out all columns in includes -#}
{%- for col in include_columns %}
    {{ col }}{%if not loop.last %},
{%- endif -%}

{%- endfor -%}
{%- endmacro -%}