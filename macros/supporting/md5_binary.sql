{#- Copyright 2019 Business Thinking LTD. trading as Datavault

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}
{%- macro md5_binary(columns, alias) -%}

{%- if columns is string -%}

CAST(MD5_BINARY(UPPER(TRIM(CAST({{columns}} AS VARCHAR)))) AS BINARY(16)) AS {{alias}}

{%- else -%}

CAST(MD5_BINARY(CONCAT(

{%- for column in columns[:-1] -%}

IFNULL(UPPER(TRIM(CAST({{column}} AS VARCHAR))), '^^'), '||',

{%- if loop.last -%}

IFNULL(UPPER(TRIM(CAST({{columns[-1]}} AS VARCHAR))), '^^') )) AS BINARY(16)) AS {{alias}}

{%- endif    -%}
{%- endfor   -%}
{%- endif    -%}
{%- endmacro -%}

