{%- macro get_hash_length(columns, schema_name, table_name, automate_dv) -%}

    {{- adapter.dispatch('get_hash_length', 'dbtvault_test')(columns=columns, schema_name=schema_name, table_name=table_name, automate_dv=automate_dv) -}}

{%- endmacro -%}

{%- macro default__get_hash_length(columns, schema_name, table_name, automate_dv) -%}

    {%- set hash_alg = var('hash', 'MD5') -%}

    {%- if not automate_dv -%}
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
    {%- elif automate_dv -%}
        {%- set hash -%}
            {{- dbtvault.hash(columns=columns, alias='HK', is_hashdiff=false, columns_to_escape=columns) -}}
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

{%- macro postgres__get_hash_length(columns, schema_name, table_name, automate_dv) -%}

    {%- set hash_alg = var('hash', 'MD5') -%}

    {%- if not automate_dv -%}
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
    {%- elif automate_dv -%}
        {%- set hash -%}
            {{- dbtvault.hash(columns=columns, alias='HK', is_hashdiff=false, columns_to_escape=columns) -}}
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