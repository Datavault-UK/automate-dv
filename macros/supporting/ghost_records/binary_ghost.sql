/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro binary_ghost(alias, hash) -%}
    {% set hash = hash | lower -%}

    {{ adapter.dispatch('binary_ghost', 'automate_dv')(alias=alias, hash=hash) }}
{%- endmacro -%}

{%- macro default__binary_ghost(alias, hash) -%}
    {%- if hash == 'md5' -%}
        {{ automate_dv.cast_binary(column_str=modules.itertools.repeat('0', 32) | join (''), alias=alias, quote=true) }}
    {%- elif hash == 'sha' -%}
        {{ automate_dv.cast_binary(column_str=modules.itertools.repeat('0', 64) | join (''), alias=alias, quote=true) }}
    {%- elif hash == 'sha1' -%}
        {{ automate_dv.cast_binary(column_str=modules.itertools.repeat('0', 40) | join (''), alias=alias, quote=true) }}
    {%- else -%}
        {{ automate_dv.cast_binary(column_str=modules.itertools.repeat('0', 32) | join (''), alias=alias, quote=true) }}
    {%- endif -%}
{%- endmacro -%}

{%- macro bigquery__binary_ghost(alias, hash) -%}
    {%- if hash == 'md5' -%}
        CAST(FROM_HEX('{{ modules.itertools.repeat('0', 32) | join ('') }}') AS BYTES)
    {%- elif hash == 'sha' -%}
        CAST(FROM_HEX('{{ modules.itertools.repeat('0', 64) | join ('') }}') AS BYTES)
    {%- elif hash == 'sha1' -%}
        CAST(FROM_HEX('{{ modules.itertools.repeat('0', 40) | join ('') }}') AS BYTES)
    {%- else -%}
        CAST(FROM_HEX('{{ modules.itertools.repeat('0', 32) | join ('') }}') AS BYTES)
    {%- endif -%}
{%- endmacro -%}

{%- macro sqlserver__binary_ghost(alias, hash) -%}
    {%- if hash == 'md5' -%}
        CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS BINARY(16)), 16) AS BINARY(16))
	{%- elif hash == 'sha' -%}
        CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS BINARY(32)), 32) AS BINARY(32))
    {%- elif hash == 'sha1' -%}
        CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS BINARY(20)), 20) AS BINARY(20))
    {%- else -%}
        CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS BINARY(16)), 16) AS BINARY(16))
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif -%}
{%- endmacro -%}
