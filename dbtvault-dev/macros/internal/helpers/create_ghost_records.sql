{%- macro create_ghost_records(source_model, source_columns, hashes, record_source) -%}

    {{- adapter.dispatch('create_ghost_records', 'dbtvault')(source_model=source_model, source_columns=source_columns, hashes=hashes, record_source='SOURCE') -}}

{%- endmacro -%}

{%- macro default__create_ghost_records(source_model, source_columns, hashes, record_source) -%}

{# Retrieve information about columns in the source data #}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}

{%- set col_definitions = [] -%}

{# Setting the ghost_string as the dictionary from ghost_string_lookup macro #}
{%- set ghost_string = dbtvault.ghost_string_lookup() -%}

    {# iterate through the column information from source model #}
{%- for col in columns -%}

    {# Setting the column name to have "" around it so it can be found in the source columns #}
    {%- set string_col = '"{}"'.format(col.column) -%}

    {# If the column name is in the source columns then do the following, else skip it #}
    {%- if string_col in source_columns -%}

        {# Return the data type of the source model columns #}
        {%- set fetched_type = col.dtype -%}
        {# Return the column name from the source model #}
        {%- set fetched_name = col.column -%}
        {# Convert the data type to a string in the format TYPE_VARCHAR #}
        {%- set type_string = 'TYPE_{}'.format(fetched_type|string()) -%}
        {# Return the corresponding ghost record #}
        {%- set fetched_string = ghost_string[type_string] -%}

        {# Ensure record source is not set as just VARCHAR #}
        {%- if fetched_name == record_source -%}
            {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS VARCHAR) AS {}".format(fetched_name) -%}

        {# If ghost record is NULL then dont cast #}
        {%- elif fetched_string == 'NULL' -%}
            {%- set col_sql = "NULL AS {}".format(fetched_name) -%}

        {# If ghost record had type BINARY cast as BINARY(16) #}
        {%- elif fetched_type == 'BINARY' -%}
            {%- set col_sql = "CAST('{}' AS BINARY(16)) AS {}".format(fetched_string, fetched_name) -%}

        {# If ghost record has type DATE then cast with TO_DATE #}
        {%- elif fetched_type == 'DATE' -%}
            {%- set col_sql = "TO_DATE('{}') AS {}".format(fetched_string, fetched_name) -%}

        {# Otherwise CAST as the necessary type #}
        {%- else -%}
            {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}

        {%- endif -%}

        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

{# Create the SELECT statement for the CTE when the macro is called. #}
SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

{%- macro postgres__create_ghost_records(source_model, source_columns, hashes, record_source) -%}

{# Retrieve information about columns in the source data #}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{# Setting the ghost_string as the dictionary from ghost_string_lookup macro #}
{%- set ghost_string = dbtvault.ghost_string_lookup() -%}

    {# iterate through the column information from source model #}
{%- for col in columns -%}

    {# Setting the column name to have "" around it so it can be found in the source columns #}
    {%- set string_col = col.column.upper() -%}

    {# If the column name is in the source columns then do the following, else skip it #}
    {%- if string_col in source_columns -%}

        {# Return the data type of the source model columns #}
        {%- set fetched_type = col.dtype -%}
        {# Return the column name from the source model #}
        {%- set fetched_name = col.column -%}
        {# Convert the data type to a string in the format TYPE_VARCHAR #}
        {%- set type_string = 'TYPE_{}'.format(fetched_type|string()) -%}
        {# Return the corresponding ghost record #}
        {%- set fetched_string = ghost_string[type_string] -%}

        {# Ensure record source is not set as just VARCHAR #}
        {%- if fetched_name|upper == record_source -%}
            {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS character varying) AS {}".format(fetched_name) -%}

        {# If ghost record is NULL then dont cast #}
        {%- elif fetched_string == 'NULL' -%}
            {%- set col_sql = "null AS {}".format(fetched_name) -%}

    {# if fetched_type is date or bytea add quotes around fetched string before casting #}
        {%- elif fetched_type == 'date' or fetched_type == 'bytea' -%}
            {%- set col_sql = "CAST('{}' AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}

        {# Otherwise CAST as the necessary type #}
        {%- else -%}
            {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}

        {%- endif -%}

        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

{# Create the SELECT statement for the CTE when the macro is called. #}
SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

{%- macro bigquery__create_ghost_records(source_model, source_columns, hashes, record_source) -%}

{# Retrieve information about columns in the source data #}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{# Setting the ghost_string as the dictionary from ghost_string_lookup macro #}
{%- set ghost_string = dbtvault.ghost_string_lookup() -%}

    {# iterate through the column information from source model #}
{%- for col in columns -%}

    {# Setting the column name to have "" around it so it can be found in the source columns #}
    {%- set string_col = '`{}`'.format(col.column) -%}

    {# If the column name is in the source columns then do the following, else skip it #}
    {%- if string_col in source_columns -%}

        {# Return the data type of the source model columns #}
        {%- set fetched_type = col.dtype -%}
        {# Return the column name from the source model #}
        {%- set fetched_name = col.column -%}
        {# Convert the data type to a string in the format TYPE_VARCHAR #}
        {%- set type_string = 'TYPE_{}'.format(fetched_type|string()) -%}
        {# Return the corresponding ghost record #}
        {%- set fetched_string = ghost_string[type_string] -%}

        {# Ensure record source is not set as just STRING #}
        {%- if fetched_name == record_source -%}
            {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS STRING) AS {}".format(fetched_name) -%}

        {# If column is a hashed column #}
        {%- elif string_col is in hashes -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS STRING) AS {}".format(fetched_name) -%}

        {# If ghost record has type DATE then cast with TO_DATE #}
        {%- elif fetched_type == 'DATE' -%}
            {%- set col_sql = "CAST('{}' AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}

        {# Otherwise CAST as the necessary type #}
        {%- else -%}
            {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}

        {%- endif -%}

        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

{# Create the SELECT statement for the CTE when the macro is called. #}
SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

{%- macro sqlserver__create_ghost_records(source_model, source_columns, hashes, record_source) -%}

{# Retrieve information about columns in the source data #}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}

{%- set col_definitions = [] -%}

{# Setting the ghost_string as the dictionary from ghost_string_lookup macro #}
{%- set ghost_string = dbtvault.ghost_string_lookup() -%}

    {# iterate through the column information from source model #}
{%- for col in columns -%}

    {# Setting the column name to have "" around it so it can be found in the source columns #}
    {%- set string_col = '"{}"'.format(col.column) -%}

    {# If the column name is in the source columns then do the following, else skip it #}
    {%- if string_col in source_columns -%}

        {# Return the data type of the source model columns #}
        {%- set fetched_type = col.dtype -%}
        {# Return the column name from the source model #}
        {%- set fetched_name = col.column -%}
        {# Convert the data type to a string in the format TYPE_VARCHAR #}
        {%- set type_string = 'TYPE_{}'.format(fetched_type|string()) -%}
        {# Return the corresponding ghost record #}
        {%- set fetched_string = ghost_string[type_string] -%}

        {# Ensure record source is not set as just VARCHAR #}
        {%- if fetched_name == record_source -%}
            {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS VARCHAR(50)) AS {}".format(fetched_name) -%}

        {# If ghost record is NULL then dont cast #}
        {%- elif fetched_string == 'NULL' -%}
            {%- set col_sql = "NULL AS {}".format(fetched_name) -%}

        {# If ghost record had type BINARY cast as BINARY(16) #}
        {%- elif fetched_type == 'BINARY(16)' -%}
            {%- set col_sql = "CAST('{}' AS BINARY(16)) AS {}".format(fetched_string, fetched_name) -%}

        {# If ghost record has type DATE then cast with TO_DATE #}
        {%- elif fetched_type == 'DATETIME2' -%}
            {%- set col_sql = "CAST('{}' AS DATETIME2) AS {}".format(fetched_string, fetched_name) -%}

        {# Otherwise CAST as the necessary type #}
        {%- else -%}
            {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}

        {%- endif -%}

        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

{# Create the SELECT statement for the CTE when the macro is called. #}
SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}
