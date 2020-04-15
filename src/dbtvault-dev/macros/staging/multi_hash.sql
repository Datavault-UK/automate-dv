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

{%- macro multi_hash(columns) -%}
{%- if columns is mapping -%}

{{- log('columns: ' ~ columns, true) -}}

    {%- for col in columns -%}

    {{- log('col: ' ~ col, true) -}}

        {% if columns[col]['sort'] is not defined -%}

            {{- dbtvault.hash(columns[col], col) -}}

        {%- elif columns[col]['sort'] is defined and columns['sort'] == true -%}

            {{- dbtvault.hash(columns[col], col, true) -}}

        {%- elif columns[col]['sort'] is not defined and columns[col]['columns'] is defined -%}

            {{- dbtvault.hash(columns[col]['columns'], col, true) -}}

        {%- endif -%}

        {%- if not loop.last -%},
{% endif %}
    {%- endfor -%}

{%- endif -%}
{%- endmacro -%}
