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

{%- macro hash_columns(columns) -%}

{%- if columns is mapping -%}

    {%- for col in columns -%}

        {% if columns[col] is mapping and columns[col].sort -%}

            {{- dbtvault.hash(columns[col]['columns'], col, columns[col]['sort']) -}}

        {%- elif columns[col] is not mapping -%}

            {{- dbtvault.hash(columns[col], col, sort=false) -}}
        
        {%- elif columns[col] is mapping and not columns[col].sort -%}

            {%- do exceptions.warn("You provided a list of columns under a 'column' key, but did not provide the 'sort' flag. HASHDIFF columns should be sorted.") -%}

            {{- dbtvault.hash(columns[col]['columns'], col) -}}

        {%- endif -%}

        {%- if not loop.last -%},
{% endif %}
    {%- endfor -%}

{%- endif -%}
{%- endmacro -%}
