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

{%- macro hash_columns(columns=none, hash_algo=none) -%}
{#-
Args: 
    columns: list(str) - Column names to hash
    hash_algo: str - The identifier of the hashing algorithm to use. One of 'MD5' or 'SHA'
-#}
{%- if columns is mapping -%}

    {%- for col in columns -%}

        {% if columns[col] is mapping and columns[col].hashdiff -%}

            {{- 
                dbtvault.hash(
                    columns=columns[col]['columns'],
                    alias=col,
                    is_hashdiff=columns[col]['hashdiff'],
                    hash_algo=hash_algo
                )
            -}}

        {%- elif columns[col] is not mapping -%}

            {{- 
                dbtvault.hash(
                    columns=columns[col],
                    alias=col,
                    is_hashdiff=hashdiff,
                    hash_algo=hash_algo
                )
            -}}
        
        {%- elif columns[col] is mapping and not columns[col].hashdiff -%}

            {%- if execute -%}
                {%- do exceptions.warn("[" ~ this ~ "] Warning: You provided a list of columns under a 'columns' key, but did not provide the 'hashdiff' flag. Use list syntax for PKs.") -%}
            {% endif %}

            {{- dbtvault.hash(columns[col]['columns'], col, false, hash_algo) -}}

        {%- endif -%}

        {%- if not loop.last -%},
{% endif %}
    {%- endfor -%}

{%- endif -%}
{%- endmacro -%}
