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


{%- macro hash(columns=none, alias=none, is_hashdiff=false, hash_algo=none) -%}
    {#- standardize columns as list -#}
    {%- set col_list = [ columns ] if columns is string else columns -%}

    {#- Alpha sort columns before hashing -#}
    {%- set col_list = col_list | sort if (is_hashdiff and columns is not string) else col_list -%}

    {# Call the appropriate database adapter hash function -#}
    {{ adapter_macro('dbtvault.hash', col_list, alias, is_hashdiff, hash_algo) }}
{%- endmacro %}

{% macro default__hash(columns, alias, is_hashdiff, hash_algo) %}
    {%- if execute -%}
        {{ exceptions.raise_compiler_error("The 'dbtvault.hash' macro does not support your database engine. Supported Databases: Snowflake, Bigquery") }}
    {%- endif -%}
{%- endmacro %}

