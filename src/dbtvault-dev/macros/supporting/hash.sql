{# Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
#}

{%- macro hash(columns, alias, sort=false) -%}

{%- set hash = var('hash', 'MD5') -%}

{#- Select hashing algorithm -#}
{%- if hash == 'MD5' -%}
    {%- set hash_alg = 'MD5_BINARY' -%}
    {%- set hash_size = 16 -%}
{%- elif hash == 'SHA' -%}
    {%- set hash_alg = 'SHA2_BINARY' -%}
    {%- set hash_size = 32 -%}
{%- else -%}
    {%- set hash_alg = 'MD5_BINARY' -%}
    {%- set hash_size = 16 -%}
{%- endif -%}

{#- Alpha sort columns before hashing -#}
{%- if sort and columns is iterable and columns is not string -%}
    {%- set columns = columns|sort -%}
{%- endif -%}

{#- If single column to hash -#}
{%- if columns is string -%}
{%- set column_str = dbtvault.as_constant(columns) -%}
CAST({{ hash_alg }}(IFNULL((UPPER(TRIM(CAST({{column_str}} AS VARCHAR)))), '^^')) AS BINARY({{ hash_size }})) AS {{alias}}

{#- If list of columns to hash -#}
{%- else -%}

CAST({{ hash_alg }}(CONCAT(

{%- for column in columns %}

{%- set column_str = dbtvault.as_constant(column) -%}

{%- if not loop.last %}
    IFNULL(UPPER(TRIM(CAST({{ column_str }} AS VARCHAR))), '^^'), '||',
{%- else %}
    IFNULL(UPPER(TRIM(CAST({{ column_str }} AS VARCHAR))), '^^') ))
AS BINARY({{ hash_size }})) AS {{alias}}
{%- endif -%}

{%- endfor -%}
{%- endif -%}

{%- endmacro -%}

