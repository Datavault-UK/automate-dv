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
{%- macro multikey(columns, prefix=none, condition=none, operator='AND') -%}

    {{- adapter.dispatch('multikey', packages = ['dbtvault'])(columns=columns, prefix=prefix, condition=condition, operator=operator) -}}

{%- endmacro %}

{%- macro default__multikey(columns, prefix=none, condition=none, operator='AND') -%}

    {%- if prefix is string -%}
        {%- set prefix = [prefix] -%}
    {%- endif -%}

    {%- if columns is string -%}
        {%- set columns = [columns] -%}
    {%- endif -%}

    {%- if condition in ['<>', '!=', '='] -%}
        {%- for col in columns -%}
            {{ prefix[0] ~ '.' if prefix }}{{ col }} {{ condition }} {{ prefix[1] ~ '.' if prefix }}{{ col }}
            {%- if not loop.last %} {{ operator }} {% endif %}
        {% endfor -%}
    {%- else -%}
        {%- if columns is iterable and columns is not string -%}
            {%- for col in columns -%}
                {{ prefix[0] ~ '.' if prefix }}{{ col }} {{ condition if condition else '' }}
                {%- if not loop.last -%} {{ "\n    " ~ operator }} {% endif -%}
            {%- endfor -%}
        {%- else -%}
            {{ prefix[0] ~ '.' if prefix }}{{ columns }} {{ condition if condition else '' }}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}