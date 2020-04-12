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

{%- macro stage(source_table, hashed_columns, added_columns) -%}

    {{ dbtvault.multi_hash(hashed_columns) -}},

    {%- if added_columns['source'] == 'include' -%}
        {{ dbtvault.add_columns(source_table=source_table, pairs=added_columns['columns']) }}
    {%- else -%}
        {{ dbtvault.add_columns(pairs=added_columns) }}
    {%- endif -%}

    FROM {{ source_table }}

{%- endmacro -%}