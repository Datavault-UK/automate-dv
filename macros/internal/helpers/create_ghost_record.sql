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

{%- for col in columns -%}
    {%- set col_name = '"{}"'.format(col.column) -%}
    {%- if col_name == src_pk -%}
        {%- if hash == 'MD5' -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(16)) AS {}".format(src_pk) -%}
        {%- elif hash == 'SHA' -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(32)) AS {}".format(src_pk) -%}
        {%- else -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(16)) AS {}".format(src_pk) -%}
        {%- endif -%}
    {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_hashdiff -%}
        {%- if hash == 'MD5' -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(16)) AS {}".format(src_hashdiff) -%}
        {%- elif hash == 'SHA' -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(32)) AS {}".format(src_hashdiff) -%}
        {%- else -%}
            {%- set col_sql = "CAST('00000000000000000000000000000000' AS BINARY(16)) AS {}".format(src_hashdiff) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_eff -%}
        {%- set col_sql = "TO_{}('1900-01-01 00:00:00') AS {}".format(col.dtype, src_eff) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_ldts -%}
        {%- set col_sql = "TO_{}('1900-01-01 00:00:00') AS {}".format(col.dtype, src_ldts) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS VARCHAR) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in src_payload -%}
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

{%- for col in columns -%}
    {%- set col_name = '`{}`'.format(col.column) -%}
    {%- if col_name == src_pk -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS STRING) AS {}".format(src_pk) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_hashdiff -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS STRING) AS {}".format(src_hashdiff) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_eff -%}
        {%- if col.dtype == 'DATE' -%}
            {%- set col_sql = "CAST('1900-01-01' AS DATE) AS {}".format(src_eff) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_eff) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_ldts -%}
    {%- do log('src_ldts: ' ~ col.dtype, info=true) -%}
        {%- if col.dtype == 'DATE' -%}
            {%- set col_sql = "CAST('1900-01-01' AS DATE) AS {}".format(src_ldts) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_ldts) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS STRING) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in src_payload -%}
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

{%- for col in columns -%}
    {%- set col_name = '`{}`'.format(col.column) -%}
    {%- if col_name == src_pk -%}
    {%- do log('src_pk data type: ' ~ col.dtype, info=true) -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS string) AS {}".format(src_pk) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_hashdiff -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS string) AS {}".format(src_hashdiff) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_eff -%}
    {%- do log('src_eff: ' ~ col.dtype, info=true) -%}
        {%- if col.dtype == 'date' -%}
            {%- set col_sql = "CAST('1900-01-01' AS date) AS {}".format(src_eff) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_eff) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_ldts -%}
    {%- do log('src_ldts: ' ~ col.dtype, info=true) -%}
        {%- if col.dtype == 'date' -%}
            {%- set col_sql = "CAST('1900-01-01' AS date) AS {}".format(src_ldts) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_ldts) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS varchar(100)) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in src_payload -%}
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

{%- for col in columns -%}
    {%- set col_name = col.column.upper() -%}
    {%- if col_name == src_pk -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS bytea) AS {}".format(src_pk) -%}
    	{%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_hashdiff -%}
        {%- set col_sql = "CAST('00000000000000000000000000000000' AS bytea) AS {}".format(src_hashdiff) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_eff -%}
	{%- if col.dtype == 'DATE' -%}
            {%- set col_sql = "CAST('1900-01-01' AS DATE) AS {}".format(src_eff) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_eff) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_ldts -%}
       	{%- if col.dtype == 'DATE' -%}
            {%- set col_sql = "CAST('1900-01-01' AS DATE) AS {}".format(src_eff) -%}
        {%- else -%}
            {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_eff) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS character varying) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in src_payload -%}
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

{%- for col in columns -%}
    {%- set col_name = '"{}"'.format(col.column) -%}

    {%- if col_name == src_pk -%}
        {%- if hash == 'MD5' -%}
            {%- set col_sql = "CAST(REPLICATE(CAST(CAST('00000000000000000000000000000000' AS tinyint) AS {}), 16) AS {}) AS {}".format('binary(16)', 'binary(16)', src_pk) -%}
	{%- elif hash == 'SHA' -%}
        	{%- set hash_alg = 'SHA2_256' -%}
		{%- set col_sql = "CAST(REPLICATE(CAST(CAST('00000000000000000000000000000000' AS tinyint) AS {}), 32) AS {}) AS {}".format('binary(32)', 'binary(32)', src_pk) -%}
        {%- else -%}
        	{%- set hash_alg = 'MD5' -%}
            	{%- set col_sql = "CAST(REPLICATE(CAST(CAST('00000000000000000000000000000000' AS tinyint) AS {}), 16) AS {}) AS {}".format('binary(16)', 'binary(16)', src_pk) -%}
        {%- endif -%}
    	{%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_hashdiff -%}
        {%- if hash == 'MD5' -%}
            {%- set col_sql = "CAST(REPLICATE(CAST(CAST('00000000000000000000000000000000' AS tinyint) AS {}), 16) AS {}) AS {}".format('binary(16)', 'binary(16)', src_hashdiff) -%}
	{%- elif hash == 'SHA' -%}
        	{%- set hash_alg = 'SHA2_256' -%}
		{%- set col_sql = "CAST(REPLICATE(CAST(CAST('00000000000000000000000000000000' AS tinyint) AS {}), 32) AS {}) AS {}".format('binary(32)', 'binary(32)', src_hashdiff) -%}
        {%- else -%}
        	{%- set hash_alg = 'MD5' -%}
            	{%- set col_sql = "CAST(REPLICATE(CAST(CAST('00000000000000000000000000000000' AS tinyint) AS {}), 16) AS {}) AS {}".format('binary(16)', 'binary(16)', src_hashdiff) -%}
        {%- endif -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_eff -%}
        {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_eff) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_ldts -%}
        {%- set col_sql = "CAST('1900-01-01 00:00:00' AS {}) AS {}".format(col.dtype, src_ldts) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name == src_source -%}
        {%- set col_sql = "CAST('DBTVAULT_SYSTEM' AS varchar(50)) AS {}".format(src_source) -%}
        {%- do col_definitions.append(col_sql) -%}

    {%- elif col_name is in src_payload -%}
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