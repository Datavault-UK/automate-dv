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

{%- macro derive_columns(source_model, columns) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}

{%- if source_model is defined and source_model is not none -%}
    {%- set source_model_cols = adapter.get_columns_in_relation(source_model) -%}
{%- endif %}

{%- if columns is mapping -%}

    {#- Add aliases of provided columns to excludes and full SQL to includes -#}
    {%- for col in columns -%}

        {%- if columns[col] | first == "!" -%}
            {%- set _ = include_columns.append("'" ~ columns[col][1:] ~ "' AS " ~ col) -%}
            {%- set _ = exclude_columns.append(col) -%}
        {%- else -%}
            {%- set _ = include_columns.append(columns[col] ~ " AS " ~ col) -%}
            {%- set _ = exclude_columns.append(col) -%}
        {%- endif %}

    {%- endfor -%}

    {#- Add all columns from source_model relation -#}
    {%- if source_model is defined and source_model is not none -%}

        {%- for source_col in source_model_cols -%}
            {%- if source_col.column not in exclude_columns -%}
                {%- set _ = include_columns.append(source_col.column) -%}
            {%- endif -%}
        {%- endfor -%}

    {%- endif %}

    {#- Print out all columns in includes -#}
    {%- for col in include_columns -%}
        {{ col }}
        {%- if not loop.last -%},
{% endif -%}
    {%- endfor -%}

{%- elif columns is undefined and source_model is defined -%}

    {#- Add all columns from source_model relation -#}
    {%- for source_col in source_model_cols -%}
        {%- if source_col.column not in exclude_columns -%}
            {%- set _ = include_columns.append(source_col.column) -%}
        {%- endif -%}
    {%- endfor -%}

    {#- Print out all columns in includes -#}
    {%- for col in include_columns -%}
        {{ col }}
        {%- if not loop.last -%},
{% endif -%}
    {%- endfor -%}

{%- else -%}

{%- if execute -%}
{{ exceptions.raise_compiler_error("Invalid column configuration:
expected format: {source_model: 'model_name', columns: 'column_mapping'}
got: {'source_model': " ~ source_model ~ ", 'columns': " ~ columns ~ "}") }}
{%- endif %}

{%- endif %}

{%- endmacro -%}