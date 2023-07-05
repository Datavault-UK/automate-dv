{%- macro get_hash_length(columns, schema_name, table_name, use_package) -%}

    {{- adapter.dispatch('get_hash_length', 'automate_dv_test')(columns=columns, schema_name=schema_name, table_name=table_name, use_package=use_package) -}}

{%- endmacro -%}

{%- macro default__get_hash_length(columns, schema_name, table_name, use_package) -%}

    {%- set hash_alg = var('hash', 'MD5') -%}

    {%- if not use_package -%}
        {%- if hash_alg == 'MD5' -%}
            {%- set hash -%}
                MD5_BINARY({{ columns }}) AS HK
            {%- endset -%}
        {%- elif hash_alg == 'SHA' -%}
            {%- set hash -%}
                SHA2_BINARY({{ columns }}) AS HK
            {%- endset -%}
        {%- else -%}
            {%- set hash -%}
                MD5_BINARY({{ columns }}) AS HK
            {%- endset -%}
        {%- endif -%}
    {%- elif use_package -%}
        {%- set hash -%}
            {{- automate_dv.hash(columns=columns, alias='HK', is_hashdiff=false, columns_to_escape=columns) -}}
        {%- endset -%}
    {%- endif -%}

    WITH CTE AS (
        SELECT {{ hash }}
            , {{ columns }} AS {{ columns }}
        FROM {{ schema_name }}.{{ table_name }}
    )
    SELECT
        {{ columns }}
        , length(HK) AS HASH_VALUE_LENGTH
    FROM CTE

{%- endmacro -%}

{%- macro postgres__get_hash_length(columns, schema_name, table_name, use_package) -%}

    {%- set hash_alg = var('hash', 'MD5') -%}

    {%- if not use_package -%}
        {%- if hash_alg == 'MD5' -%}
            {%- set hash -%}
                DECODE(MD5("{{ columns }}"), 'hex') AS HK
            {%- endset -%}
        {%- elif hash_alg == 'SHA' -%}
            {%- set hash -%}
                SHA256('{{ columns }}') AS HK
            {%- endset -%}
        {%- else -%}
            {%- set hash -%}
                DECODE(MD5("{{ columns }}"), 'hex') AS HK
            {%- endset -%}
        {%- endif -%}
    {%- elif use_package -%}
        {%- set hash -%}
            {{- automate_dv.hash(columns=columns, alias='HK', is_hashdiff=false, columns_to_escape=columns) -}}
        {%- endset -%}
    {%- endif -%}

    WITH CTE AS (
        SELECT {{ hash }}
            , "{{ columns }}" AS {{ columns }}
        FROM "{{ schema_name }}".{{ table_name }}
    )
    SELECT
        {{ columns }}
        , length(HK) AS HASH_VALUE_LENGTH
    FROM CTE

{%- endmacro -%}