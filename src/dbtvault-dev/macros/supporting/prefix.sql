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

{%- macro prefix(columns, prefix_str) -%}

    {{ log('this: ' ~ this, true)}}
    {{ log('columns: ' ~ columns, true)}}

    {%- for col in columns -%}

        {%- if col is mapping -%}

            {{ log('col: ' ~ col, true)}}

            {{- dbtvault.prefix([col['source_column']], prefix_str) -}}

            {%- if not loop.last -%} , {% endif %}

        {%- else -%}

            {% if col is iterable and col is not string %}

                {{- dbtvault.prefix(col, prefix_str) -}}

            {%- else -%}

                {{- prefix_str}}.{{col.strip() -}}

            {%- endif -%}

            {%- if not loop.last -%} , {% endif %}

        {%- endif -%}

    {%- endfor -%}

{%- endmacro -%}