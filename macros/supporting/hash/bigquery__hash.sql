
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

{%- macro _bigquery_standardize_hash_input(expr) -%}
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
  IFNULL(NULLIF(UPPER(TRIM(CAST({{- expr }} AS STRING))), ''), '^^')
{%- endmacro -%}

{%- macro _bigquery_hash_single(expr, hash_algo) -%}
{#-
    Hashes an expression using the provided hashing algorithm.

    Arguments:
        expr {str} - The sql expression to hash
        hash_algo {str} - The hashing algorithm to use. Currently only 'MD5' is allowed.

    Example:
        _bigquery_hash_single('ABC') -> '902fbdd2b1df0c4f70b4a5d23525e932'

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


{%- macro bigquery__hash(columns, alias, hashdiff, hash_algo) -%}
{#-
    Hash a field or list of fields into a single string value

    Arguments:
        columns {Union[str, List(str)]} - either a string representing a column or a list of columns to be hashed
        alias {str} - the name of the final hashed column
        hashdiff {bool} - is this a hashdiff? if true, columns are sorted in ascending order before hashing for consistency.
        hash_algo {str} - The hashing algorithm to use. Currently only 'MD5' is supported.

    Example:

        Input Table:

        | size | color |
        |------+-------|
        | S    | red   |
        | S    | blue  |
        | M    | red   |

        Example 1:

        bigquery__hash('size', 'size_hash')

        Output Table:

        | size | color | size_hash                        |
        |------+-------+----------------------------------|
        | S    | red   | 5dbc98dcc983a70728bd082d1a47546e |
        | S    | blue  | 5dbc98dcc983a70728bd082d1a47546e |
        | M    | red   | 69691c7bdcc3ce6d5d8a1361f22d04ac |


        Example 2:

        bigquery__hash(['size', 'color'], 'my_hashdiff', hashdiff=true)

        Output Table:

        | size | color | my_hashdiff           |
        |------+-------+-----------------------|
        | S    | red   | < Hash of 'RED||S' >  |
        | S    | blue  | < Hash of 'BLUE||S' > |
        | M    | red   | < Hash of 'RED||M' >  |

    Raises:
        Compilation Error - if an unsupported hashing algorithm is passed in
-#}
    {%- if hash_algo != 'MD5' and execute -%}
        {{ exceptions.raise_compiler_error("The 'bigquery__hash' macro does not support the hash algorithm " ~ hash_algo ~ ". Supported hash algorithms are: 'MD5'") }}
    {%- endif -%}

    {#- Map the columns list to encoded standardized list of column values -#}
    {%- set columns_prehash -%}
CONCAT(
        {%- for col in columns %}
	{{ dbtvault._bigquery_standardize_hash_input(col) }} {%- if not loop.last -%} , '||', {%- endif %}
        {%- endfor %}
)
    {%- endset -%}
		{{ dbtvault._bigquery_hash_single(columns_prehash, hash_algo) }} AS {{ alias }}
{%- endmacro -%}
