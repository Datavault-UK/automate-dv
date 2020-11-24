{%- macro hash_columns(columns=none, hash_algo=none) -%}
    {#-
    Hashes a the values of given list of columns using the provided hash algorithm

    Args:
        columns {Mapping[str, Union[str, Mapping]} - Column names to hash. Either a string or a mapping with
            a boolean value at the "hashdiff" key and a list of column names as the "columns" key (see example)
        hash_algo: str - The identifier of the hashing algorithm to use.

    Example 1:
        if columns is

        {
            'EXAMPLE_HK': 'SRC_COLUMN',
            'EXAMPLE2_HK': 'SRC_COLUMN2'

        }

        The resulting output will have columns

        EXAMPLE_HK = HASH(SRC_COLUMN)
        EXAMPLE2_HK = HASH(SRC_COLUMN2)

    Example 2:

        if columns is

        {
            EXAMPLE_HK: {
                hashdiff: true
                columns: ['B', 'C', 'A']
            }
        }

        the resulting output will have columns

        EXAMPLE_HK = HASH(A||B||C)


    -#}
    {%- if columns is mapping -%}
        {%- for output_col in columns -%}

            {%- set src_col_config = columns[output_col] -%}
            {%- set is_hashdiff = src_col_config['hashdiff'] -%}
            {%-
                if
                    execute
                    and is_hashdiff is not defined
                    and src_col_config['columns'] is defined
                    and src_col_config['columns'] is iterable
                    and src_col_config['columns'] is not string
                    and src_col_config['columns'] is not mapping
             -%}
                {%- do exceptions.warn('[' ~ this ~ '] Warning: You provided a list of columns under  "' ~ (this | string).split('.') | last ~ '.'  ~ output_col ~ '.columns", but did not provide the "hashdiff" flag. Use list syntax for PKs.') -%}
            {%- endif -%}

            {{-
                dbtvault_bq.hash(
                    columns=src_col_config['columns'] if src_col_config is mapping else src_col_config,
                    alias=output_col,
                    is_hashdiff=is_hashdiff,
                    hash_algo=hash_algo
                )
            -}}

            {%- if not loop.last -%} ,
{%- endif -%}

        {%- endfor -%}
    {%- endif -%}
{%- endmacro -%}
