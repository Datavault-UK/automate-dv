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

{%- macro hash(columns, alias, sort=false) -%}

{#- Alpha sort columns before hashing -#}
{%- if sort and columns is iterable and columns is not string -%}
{%- set columns = columns|sort -%}
{%- endif -%}

{%- if columns is string %}
    {{ dbt_utils.surrogate_key([columns]) }} AS {{alias}}
{%- else %}
    {{ dbt_utils.surrogate_key(columns) }} AS {{alias}}
{%- endif -%}

{%- endmacro -%}
