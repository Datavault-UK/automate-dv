{# Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
#}


{%- macro _standardize_hash_input(expr, output_str_if_null='^^') -%}
{#-
    Casts any field into a standardized string to prepare for hashing

    Arguments:
        expr {str} - the expression to standardize for hashing
        output_str_if_null {str} - the string to output if the input expression is null (default: '^^')

    Example expression input -> output:

    123 -> '123'
    ' a123  ' -> 'A123'
    '' -> '^^'
    TRUE -> 'TRUE'
-#}
    IFNULL(NULLIF(UPPER(TRIM(CAST({{- expr }} AS {{ dbtvault.type_string() }}))), ''), '{{ output_str_if_null }}')
{%- endmacro %}


{%- macro hash(columns=none, alias=none, is_hashdiff=false, hash_algo=none) -%}
{#-
    Hash a field or list of fields into a single string value

    Arguments:
        columns {Union[str, List(str)]} - either a string representing a column or a list of columns to be hashed
        alias {str} - the name of the final hashed column
        hashdiff {bool} - is this a hashdiff? if true, columns are sorted in ascending order before hashing for consistency. (default: false)
        hash_algo {str} - The hashing algorithm to use. Depends on the database adapter.
                            Snowflake: MD5, SHA
                            Bigquery: MD5

    Example:

        Input Table:

        | size | color |
        |------+-------|
        | s    | red   |
        | s    | blue  |
        | m    | red   |


        Example 1:

        hash('size', 'size_hash')

        Output Table:

        | size | color | size_hash         |
        |------+-------+-------------------|
        | s    | red   | < Hash of 'S'  >  |
        | s    | blue  | < Hash of 'S'  >  |
        | m    | red   | < Hash of 'M'  >  |


        Example 2:

        hash(['size', 'color'], 'my_hashdiff', hashdiff=true)

        Output Table:

        | size | color | my_hashdiff           |
        |------+-------+-----------------------|
        | s    | red   | < Hash of 'RED||S'  > |
        | s    | blue  | < Hash of 'BLUE||S' > |
        | m    | red   | < Hash of 'RED||M'  > |

    Raises:
        Compilation Error - if an unsupported hashing algorithm is passed in
-#}
    {#- standardize columns as list -#}
    {%- set col_list = [ columns ] if columns is string else columns -%}

    {#- Alpha sort columns before hashing -#}
    {%- set col_list = col_list | sort if (is_hashdiff and columns is not string) else col_list -%}

    {# Standardize and concatenate the list of columns using the delimeter #}
    {%- set columns_prehash -%}
CONCAT(
        {%- for col in col_list %}
            {{- dbtvault._standardize_hash_input(col) }}
            {%- if not loop.last -%}, '||', {%- endif %}
        {%- endfor %}
)
    {%- endset -%}

    {# Call the appropriate database adapter hash function -#}
    {{ adapter_macro('dbtvault.hash', columns_prehash, hash_algo) }} AS {{ alias }}
{%- endmacro %}


{% macro default__hash(columns, alias, is_hashdiff, hash_algo) %}
    {%- if execute -%}
        {{ exceptions.raise_compiler_error("The 'dbtvault.hash' macro does not support your database engine. Supported Databases: Snowflake, Bigquery") }}
    {%- endif -%}
{%- endmacro %}


{%- macro bigquery__hash(expr, hash_algo) -%}
{#-
    Hashes an expression using the provided hashing algorithm.

    Arguments:
        expr {str} - The sql expression to hash
        hash_algo {str} - The hashing algorithm to use. Currently only 'MD5' is allowed. (default: 'MD5')

    Example:
        bigquery__hash('ABC') -> '902fbdd2b1df0c4f70b4a5d23525e932'

    Raises:
        Compilation Error - if an unsupported hashing algorithm is passed in
-#}
    {%- if hash_algo != 'MD5' and execute -%}
        {% do exceptions.raise_compiler_error("The '_bigquery_hash_single' macro does not support the hash algorithm ''" ~ hash_algo ~ "''. Supported hash algorithms are: 'MD5'") %}
    {%- endif -%}
    {%- if hash_algo == 'MD5' -%}
TO_HEX(MD5(
	{{ expr|indent}}
))
    {%- endif -%}
{%- endmacro -%}


 {%- macro snowflake__hash(expr, hash_algo) -%}
{#-
    Hashes an expression using the provided hashing algorithm.

    Arguments:
        expr {str} - The sql expression to hash
        hash_algo {str} - The hashing algorithm to use. Currently only 'MD5' is allowed. (default: 'MD5')

    Example:
        snowflake__hash('ABC') -> '902fbdd2b1df0c4f70b4a5d23525e932'

    Raises:
        Compilation Error - if an unsupported hashing algorithm is passed in
-#}
    {%- if hash_algo == 'MD5' -%}
        {%- set db_hash_algo = 'MD5_BINARY' -%}
        {%- set hash_size = 16 -%}
    {%- elif hash_algo == 'SHA' -%}
        {%- set db_hash_algo = 'SHA2_BINARY' -%}
        {%- set hash_size = 32 -%}
    {%- else -%}
        {% do   exceptions.raise_compiler_error(
                    "_snowflake_hash_single received an unknown hashing algorithm: " ~ hash_algo ~
                    ". Supported hashing algorithms are: 'MD5', 'SHA'"
                )
        %}
    {%- endif -%}

CAST({{ db_hash_algo }}({{ expr }}) AS BINARY({{ hash_size }}))

{%- endmacro -%}