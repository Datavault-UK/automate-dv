{#- Copyright 2019 Business Thinking LTD. trading as Datavault

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}
{%- macro validate_columns(select_columns, source_columns, source_relation) -%}

{%- if source_columns -%}
    {%- for col in select_columns -%}
        {%- if col not in source_columns -%}
            {{ exceptions.raise_compiler_error("Column '" ~ col ~ "' not present in source '" ~ source_relation.table ~ "', either incorrect source or incorrect source column name.") }}
        {%- endif -%}
    {%- endfor -%}
{%- endif -%}

{%- endmacro -%}