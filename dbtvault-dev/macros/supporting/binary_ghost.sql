{%- macro binary_ghost(alias, hash) -%}
    {{ adapter.dispatch('binary_ghost', 'dbtvault')(alias=alias, hash=hash) }}
{%- endmacro -%}

{%- macro default__binary_ghost(alias, hash) -%}
    {%- if hash == 'MD5' -%}
        CAST('00000000000000000000000000000000' AS BINARY(16)) AS {{alias}}
    {%- elif hash == 'SHA' -%}
        CAST('0000000000000000000000000000000000000000000000000000000000000000' AS BINARY(32)) AS {{alias}} -%}
    {%- else -%}
        CAST('00000000000000000000000000000000' AS BINARY(16)) AS {{alias}} -%}
    {%- endif -%}
{%- endmacro -%}

{%- macro bigquery__binary_ghost(alias, hash) -%}
    CAST('00000000000000000000000000000000' AS STRING) AS {{alias}}
{%- endmacro -%}

{%- macro databricks__binary_ghost(alias, hash) -%}
    CAST('00000000000000000000000000000000' AS string) AS {{alias}}
{%- endmacro -%}

{%- macro postgres__binary_ghost(alias, hash) -%}
    CAST('00000000000000000000000000000000' AS bytea) AS {{alias}}
{%- endmacro -%}

{%- macro sqlserver__binary_ghost(alias, hash) -%}
    {%- if hash == 'MD5' -%}
        CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS 'binary(16)'), 16) AS 'binary(16)') AS {{alias}}
	{%- elif hash == 'SHA' -%}
        {%- set hash_alg = 'SHA2_256' -%}
		CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS 'binary(32)'), 32) AS 'binary(32)') AS {{alias}}
    {%- else -%}
        {%- set hash_alg = 'MD5' -%}
        CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS 'binary(16)'), 16) AS 'binary(16)') AS {{alias}}
    {%- endif -%}
{%- endmacro -%}
