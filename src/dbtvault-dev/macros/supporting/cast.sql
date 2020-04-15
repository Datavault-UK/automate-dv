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

{%- macro cast(columns, prefix=none) -%}

{#- If a string or list -#}
{%- if columns is iterable -%}

    {#- If only single string provided -#}
    {%- if columns is string -%}

        {{columns}}

    {%- else -%}

        {%- for column in columns -%}

            {#- Output String if just a string -#}
            {%- if column is string -%}
                {% if prefix %}
                    {{ dbtvault.prefix([column], prefix) }}
                {%- else %}
                    {{ column }}
                {%- endif -%}

            {#- Recurse if a list of lists (i.e. multi-column key) -#}
            {%- elif column|first is iterable and column|first is not string -%}
                {{ dbtvault.cast(column, prefix) }}

            {#- Otherwise it is a standard list -#}
            {%- else -%}

                {#- Make sure it is a triple -#}
                {%- if column|length == 3 %}
                    {% if prefix -%}
                    CAST({{ dbtvault.prefix([column[0]], prefix) }} AS {{ column[1] }}) AS {{ column[2] }}
                    {%- else -%}
                    CAST({{ column[0] }} AS {{ column[1] }}) AS {{ column[2] }}
                    {%- endif -%}
                {%- endif -%}

            {%- endif -%}

            {#- Add trailing comma if not last -#}
            {%- if not loop.last -%} , {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}

