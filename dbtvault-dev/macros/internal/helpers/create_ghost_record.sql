{%- macro create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('create_ghost_record', 'dbtvault')(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                           src_payload=src_payload, src_extra_columns=src_extra_columns,
                                           src_eff=src_eff, src_ldts=src_ldts,
                                           src_source=src_source, source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set string_columns = [] -%}
    {%- do string_columns.append(src_payload) -%}
    {%- if src_extra_columns != none -%}
        {%- do string_columns.append(src_extra_columns) -%}
    {%- endif -%}

{%- for col in columns -%}
    {%- set col_name = '"{}"'.format(col.column) -%}
    {%- if (col_name == src_pk) or (col_name == src_hashdiff) -%}
        {%- if hash == 'MD5' -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(16)) AS {}".format(col_name) -%}
        {%- elif hash == 'SHA' -%}
            {%- set col_sql = "CAST('0000000000000000000000000000000000000000000000000000000000000000' AS BINARY(32)) AS {}".format(col_name) -%}
        {%- else -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(16)) AS {}".format(col_name) -%}
        {%- endif -%}
    {%- do col_definitions.append(col_sql) -%}

    {%- elif (col_name == src_eff) or (col_name == src_ldts) -%}
        {%- set col_sql = "TO_{}('1900-01-01 00:00:00') AS {}".format(col.dtype, col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS VARCHAR) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in string_columns -%}
        {% set col_sql = "NULL AS {}".format(col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

{%- macro bigquery__create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set string_columns = [] -%}
    {%- do string_columns.append(src_payload) -%}
    {%- if src_extra_columns != none -%}
        {%- do string_columns.append(src_extra_columns) -%}
    {%- endif -%}

{%- for col in columns -%}
    {%- set col_name = '`{}`'.format(col.column) -%}
    {%- if (col_name == src_pk) or (col_name == src_hashdiff) -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS STRING) AS {}".format(col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif (col_name == src_eff) or (col_name == stc_ldts) -%}
        {%- if col.dtype == 'DATE' -%}
            {%- set col_sql = "CAST('1900-01-01' AS DATE) AS {}".format(col_name) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, col_name) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS STRING) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in string_columns -%}
        {% set col_sql = "CAST(NULL AS {}) AS {}".format(col.dtype, col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

{%- macro databricks__create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set string_columns = [] -%}
    {%- do string_columns.append(src_payload) -%}
    {%- if src_extra_columns != none -%}
        {%- do string_columns.append(src_extra_columns) -%}
    {%- endif -%}

{%- for col in columns -%}
    {%- set col_name = '`{}`'.format(col.column) -%}
    {%- if (col_name == src_pk) or (col_name == src_hashdiff) -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS string) AS {}".format(col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif (col_name == src_eff) or (col_name == src_ldts) -%}
        {%- if col.dtype == 'date' -%}
            {%- set col_sql = "CAST('1900-01-01' AS date) AS {}".format(col_name) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, col_name) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS varchar(100)) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in string_columns -%}
        {% set col_sql = "NULL AS {}".format(col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

{%- macro postgres__create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set string_columns = [] -%}
    {%- do string_columns.append(src_payload) -%}
    {%- if src_extra_columns != none -%}
        {%- do string_columns.append(src_extra_columns) -%}
    {%- endif -%}

{%- for col in columns -%}
    {%- set col_name = col.column.upper() -%}
    {%- if (col_name == src_pk) or (col_name == src_hashdiff) -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS bytea) AS {}".format(col_name) -%}
    	{%- do col_definitions.append(col_sql) -%}

    {%- elif (col_name == src_eff) or (col_name == src_ldts) -%}
	{%- if col.dtype == 'date' -%}
            {%- set col_sql = "CAST('1900-01-01' AS date) AS {}".format(col_name) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, col_name) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS character varying) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in string_columns -%}
        {% set col_sql = "NULL AS {}".format(col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

{%- macro sqlsever__create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set string_columns = [] -%}
    {%- do string_columns.append(src_payload) -%}
    {%- if src_extra_columns != none -%}
        {%- do string_columns.append(src_extra_columns) -%}
    {%- endif -%}

{%- for col in columns -%}
    {%- set col_name = '"{}"'.format(col.column) -%}
    {%- if (col_name == src_pk) or (col_name == src_hashdiff) -%}
        {%- if hash == 'MD5' -%}
            {%- set col_sql = "CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS {}), 16) AS {}) AS {}".format('binary(16)', 'binary(16)', col_name) -%}
	{%- elif hash == 'SHA' -%}
        	{%- set hash_alg = 'SHA2_256' -%}
		{%- set col_sql = "CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS {}), 32) AS {}) AS {}".format('binary(32)', 'binary(32)', col_name) -%}
        {%- else -%}
        	{%- set hash_alg = 'MD5' -%}
            	{%- set col_sql = "CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS {}), 16) AS {}) AS {}".format('binary(16)', 'binary(16)', col_name) -%}
        {%- endif -%}
    	{%- do col_definitions.append(col_sql) -%}

    {%- elif (col_name == src_eff) or (col_name == src_ldts) -%}
        {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS varchar(50)) AS {}".format(src_source) -%}
        {%- do log('col_sql: ' ~ col_sql, info=true) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in string_columns -%}
        {% set col_sql = "CAST(NULL AS varchar(50)) AS {}".format(col_name) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

SELECT
    {% for col in col_definitions -%}
    {{ col }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}