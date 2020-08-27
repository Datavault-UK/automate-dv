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
{%- macro multikey(columns, alias=none, condition=none, operator='AND') -%}

    {{- adapter_macro('dbtvault.multikey', columns=columns, alias=alias, condition=condition, operator=operator) -}}

{%- endmacro %}

{%- macro default__multikey(columns, alias=none, condition=none, operator='AND') -%}

    {%- if alias is string -%}
        {%- set alias = [alias] -%}
    {%- endif -%}

    {%- if columns is string -%}
        {%- set columns = [columns] -%}
    {%- endif -%}

    {%- if condition in ['<>', '!=', '='] -%}
        {%- for col in columns -%}
            {{ alias[0] ~ '.' if alias }}{{ col }} {{ condition }} {{ alias[1] ~ '.' if alias }}{{ col }}
            {%- if not loop.last %} {{ operator }} {% endif %}
        {% endfor -%}
    {%- else -%}
        {%- if columns is iterable and columns is not string -%}
            {%- for col in columns -%}
                {{ alias[0] ~ '.' if alias }}{{ col }} {{ condition if condition else '' }}
                {%- if not loop.last %} {{ operator }} {% endif %}
            {% endfor -%}
        {%- else -%}
            {{ alias[0] ~ '.' if alias }}{{ columns }} {{ condition if condition else '' }}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}