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
{%- macro hash_columns(columns=none) -%}

    {{- adapter_macro('dbtvault.hash_columns', columns=columns) -}}

{%- endmacro %}

{%- macro default__hash_columns(columns=none) -%}

{%- if columns is mapping -%}

    {%- for col in columns -%}

        {% if columns[col] is mapping and columns[col].is_hashdiff -%}

            {{- dbtvault.hash(columns=columns[col]['columns'], 
                              alias=col, 
                              is_hashdiff=columns[col]['is_hashdiff']) -}}

        {%- elif columns[col] is not mapping -%}

            {{- dbtvault.hash(columns=columns[col], 
                              alias=col, 
                              is_hashdiff=false) -}}
        
        {%- elif columns[col] is mapping and not columns[col].is_hashdiff -%}

            {%- if execute -%}
                {%- do exceptions.warn("[" ~ this ~ "] Warning: You provided a list of columns under a 'columns' key, but did not provide the 'is_hashdiff' flag. Use list syntax for PKs.") -%}
            {% endif %}

            {{- dbtvault.hash(columns=columns[col]['columns'], 
                              alias=col) -}}

        {%- endif -%}

        {%- if not loop.last -%},
{% endif %}
    {%- endfor -%}

{%- endif -%}
{%- endmacro -%}
