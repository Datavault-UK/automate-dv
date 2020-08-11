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
{%- macro derive_columns(source_relation=none, columns=none) -%}

    {{- adapter_macro('dbtvault.derive_columns', source_relation=source_relation, columns=columns) -}}

{%- endmacro %}

{%- macro default__derive_columns(source_relation=none, columns=none) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}

{%- if source_relation is defined and source_relation is not none -%}
    {%- set source_model_cols = adapter.get_columns_in_relation(source_relation) -%}
{%- endif %}

{%- if columns is mapping and columns is not none -%}

    {#- Add aliases of provided columns to excludes and full SQL to includes -#}
    {%- for col in columns -%}

        {% set column_str = dbtvault.as_constant(columns[col]) %}

        {%- set _ = include_columns.append(column_str ~ " AS " ~ col) -%}
        {%- set _ = exclude_columns.append(col) -%}

    {%- endfor -%}

    {#- Add all columns from source_model relation -#}
    {%- if source_relation is defined and source_relation is not none -%}

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

{%- elif columns is none and source_relation is not none -%}

    {#- Add all columns from source_model relation -#}
    {%- for source_col in source_model_cols -%}
        {%- if source_col.column not in exclude_columns -%}
            {%- set _ = include_columns.append(source_col.column) -%}
        {%- endif -%}
    {%- endfor -%}

    {#- Print out all columns in includes -#}
    {%- for col in include_columns -%}
        {{ col }}
        {{- ',\n' if not loop.last -}}

    {%- endfor -%}

{%- else -%}

{%- if execute -%}
{{ exceptions.raise_compiler_error("Invalid column configuration:
expected format: {source_relation: Relation, columns: 'column_mapping'}
got: {'source_relation': " ~ source_relation ~ ", 'columns': " ~ columns ~ "}") }}
{%- endif %}

{%- endif %}

{%- endmacro -%}