{%- macro create_ghost_records(source_model, source_columns) -%}

    {{- adapter.dispatch('create_ghost_records', 'dbtvault')(source_model=source_model, source_columns=source_columns) -}}

{%- endmacro -%}

{%- macro default__create_ghost_records(source_model, source_columns) -%}

{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
-- Retrieve information about columns in the source data
{%- set col_definitions = [] -%}
{%- set ghost_string = dbtvault.ghost_string_lookup() -%}
-- Set ghost_string as the dictionary from ghost_string_lookup macro


{%- for col in columns -%}
-- iterate through the column information from source model
    {%- do log("columns: " ~ col, true) -%}
    {%- set string_col = '"{}"'.format(col.column) -%}
    -- Setting the column name to have "" around it so it can be found in the source columns
    {%- if string_col in source_columns -%}
    -- If the column name is in the source columns then do the following, else skip it
        {%- set fetched_type = col.dtype -%}
        {%- do log("type: " ~ fetched_type, true) -%}
    -- Return the data type of the source model columns
        {%- set fetched_name = col.column -%}
        {%- do log("name: " ~ fetched_name, true) -%}
    -- Return the column name from the source model
        {%- set type_string = 'TYPE_{}'.format(fetched_type|string()) -%}
    -- Convert the data type to a string in the format 'TYPE_VARCHAR
        {%- set fetched_string = ghost_string[type_string] -%}
        {%- do log("string: " ~ fetched_string, true) -%}
    -- Return the corresponding ghost record
        {%- if fetched_string == 'NULL' -%}
            {%- set col_sql = "CAST(NULL AS VARCHAR) AS {}".format(fetched_name) -%}
    -- If ghost record is NULL then don't cast
        {%- elif fetched_type == 'BINARY' -%}
            {%- set col_sql = "CAST('{}' AS BINARY(16)) AS {}".format(fetched_string, fetched_name) -%}
    -- If ghost record had type BINARY cast as BINARY(16)
        {%- elif fetched_type == 'DATE' -%}
            {%- set col_sql = "{} AS {}".format(fetched_string, fetched_name) -%}
    -- IF ghost record has type DATE then don't cast
        {%- else -%}
            {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}
    -- Otherwise CAST as the necessary type
        {%- endif -%}

        {%- do log("col_sql: " ~ col_sql, true) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}
-- Create the SELECT statement for the CTE when the macro is called.
SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}