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

{%- macro _snowflake_standardize_hash_input(expr) -%}
{#-
    Casts any field into a standardized string to prepare for hashing

    Arguments:
        expr {str} - the expression to standardize for hashing

    Example expression input -> output:
    
    123 -> '123'
    ' a123  ' -> 'A123'
    '' -> '^^'
    TRUE -> 'TRUE'        
-#}
    IFNULL(NULLIF(UPPER(TRIM(CAST({{- expr }} AS VARCHAR))), ''), '^^')
{%- endmacro -%}


{%- macro _snowflake_hash_single(expr, hash_algo) -%}
{#-
    Hashes an expression using the provided hashing algorithm.

    Arguments:
        expr {str} - The sql expression to hash
        hash_algo {str} - The hashing algorithm to use. Currently only 'MD5' is allowed. (default: 'MD5')

    Example: 
        _snowflake_hash_single('ABC') -> '902fbdd2b1df0c4f70b4a5d23525e932'
    
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

CAST({{ db_hash_algo }}({{ _snowflake_standardize_hash_input(expr)}}) AS BINARY({{ hash_size }}))

{%- endmacro -%}

{%- macro snowflake__hash(columns, alias, hashdiff, hash_algo) -%}
{#-
    Hash a field or list of fields into a single string value

    Arguments:
        columns {Union[str, List(str)]} - either a string representing a column or a list of columns to be hashed
        alias {str} - the name of the final hashed column
        hashdiff {bool} - is this a hashdiff? if true, columns are sorted in ascending order before hashing for consistency. (default: false)
        hash_algo {str} - The hashing algorithm to use. Currently only 'MD5' is supported (default: 'MD5')

    Example:

        Input Table:
        
        | size | color |
        |------+-------|
        | s    | red   |
        | s    | blue  |
        | m    | red   |
        
        
        Example 1:
        
        snowflake__hash('size', 'size_hash')

        Output Table:

        | size | color | size_hash         |
        |------+-------+-------------------|
        | s    | red   | < Hash of 'S'  >  |
        | s    | blue  | < Hash of 'S'  >  |
        | m    | red   | < Hash of 'M'  >  |


        Example 2:
        
        snowflake__hash(['size', 'color'], 'my_hashdiff', hashdiff=true)

        Output Table:

        | size | color | my_hashdiff           |
        |------+-------+-----------------------|
        | s    | red   | < Hash of 'RED||S'  > |
        | s    | blue  | < Hash of 'BLUE||S' > |
        | m    | red   | < Hash of 'RED||M'  > |       
    
    Raises:
        Compilation Error - if an unsupported hashing algorithm is passed in
-#}
    {#- Select hashing algorithm -#}
    {%- if hash_algo not in ['MD5', 'SHA'] and execute -%}
        {% do exceptions.raise_compiler_error("The dbtvault Snowflake adapter only supports 'MD5' and 'SHA' hashing algorithms.") %}
    {%- endif -%}

    {#- Map the columns list to encoded standardized list of column values -#}
     {%- set columns_prehash -%}
CONCAT(
        {%- for col in columns %}
	{{ dbtvault._snowflake_standardize_hash_input(col) }} {%- if not loop.last -%} , '||', {%- endif %}
        {%- endfor %}
)
    {%- endset -%}
		{{ dbtvault._snowflake_hash_single(columns_prehash, hash_algo) }} AS {{ alias }}
{%- endmacro -%}


