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

{%- macro expand_column_list(columns=none) -%}

{%- if not columns -%}
    {%- if execute -%}
         {{ exceptions.raise_compiler_error("Expected a list of columns, got: " ~ columns) }}
    {%- endif -%}
{%- endif -%}

{%- set col_list = [] -%}

{%- if columns is iterable -%}

    {%- for col in columns -%}

        {%- if col is string -%}

            {%- set _ = col_list.append(col) -%}

        {#- If list of lists -#}
        {%- elif col is iterable and col is not string -%}

            {%- if col is mapping -%}

                {%- set _ = col_list.append(col) -%}

            {%- else -%}

                {%- for cols in col -%}

                    {%- set _ = col_list.append(cols) -%}

                {%- endfor -%}

            {%- endif -%}

        {%- endif -%}

    {%- endfor -%}
{%- endif -%}

{{ return(col_list) }}

{%- endmacro -%}