{%- macro check_table_exists(model_name) -%}

    {%- set source_relation = adapter.get_relation(database=target.database,
                                                   schema=dbtvault_test.get_schema_name(),
                                                   identifier=model_name) -%}

    {%- if source_relation -%}
        {%- do log("Table '{}' exists.".format(model_name), true) -%}
        {%- do return(True) %}
    {%- else -%}
        {%- do log("Table '{}' does not exist.".format(model_name), true) -%}
        {%- do return(False) %}
    {%- endif -%}

    {%- do return(False) %}

{%- endmacro -%}

{%- macro check_source_exists(source_name, table_name) -%}

    {%- set source = source(source_name, table_name) -%}
    {%- set source_relation = adapter.get_relation(database=source.database,
                                                   schema=source.schema,
                                                   identifier=source.identifier)-%}


    {%- if source_relation.is_table or source_relation.is_view -%}
        {%- do log("Source '{}:{}' exists.".format(source_name, table_name), true) -%}
        {%- do return(True) %}
    {%- else -%}
        {%- do log("Source '{}:{}' does not exist.".format(source_name, table_name), true) -%}
        {%- do return(False) %}
    {%- endif -%}

{%- endmacro -%}


{%- macro recreate_schema(schema_name=None) -%}

    {%- if not schema_name -%}
        {%- set schema_name = dbtvault_test.get_schema_name() %}
    {%- endif -%}

    {%- set schema_relation = api.Relation.create(database=target.database, schema=schema_name) -%}

    {%- do adapter.drop_schema(schema_relation) -%}
    {%- do adapter.create_schema(schema_relation) -%}

{%- endmacro -%}


{%- macro get_hash_length(columns, schema_name, table_name, automate_dv) -%}

    {{- adapter.dispatch('get_hash_length', 'dbtvault_test')(columns=columns, schema_name=schema_name, table_name=table_name, automate_dv=automate_dv) -}}

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


{% macro hash_database_table(model_name, unhashed_table_name, hashed_columns, payload_columns) -%}

    {%- set hash_cols = [] -%}
    {%- set payload_cols = [] -%}

    {%- for cols in hashed_columns -%}
        {%- set hash_str = dbtvault.escape_column_name(cols) -%}
        {%- do hash_cols.append("{} AS {}".format(hash_str, cols|lower)) -%}
    {%- endfor -%}

    {%- for cols in payload_columns -%}
        {%- set payload_str = dbtvault.escape_column_name(cols) -%}
        {%- do payload_cols.append("{} AS {}".format(payload_str, cols|lower)) -%}
    {%- endfor -%}

WITH core_table AS (
    SELECT
        {%- for col in hash_cols %}
        {{ col }},
        {%- endfor -%}
        {%- for col in payload_cols %}
        {{ col }}
            {%- if not loop.last -%},{%- endif -%}
        {%- endfor %}
    FROM "DEVELOPMENT_DBTVAULT_USER"."{{- unhashed_table_name }}"
),

positions as (
    SELECT
        {%- for cols in hashed_columns|map('lower') %}
        POSITION('(' in {{ cols }}) + 2 as start_position_{{ cols }},
        POSITION(')' in {{ cols }}) - 1 AS end_position_{{ cols }},
        {{ cols }},
        {%- endfor %}
        {%- for cols in payload_columns|map('lower') %}
        {{ cols }}
        {%- if not loop.last %},{%- endif -%}
        {%- endfor %}
    FROM core_table
),

hashing_string as (
    SELECT
        {%- for cols in hashed_columns|map('lower') %}
        SUBSTRING({{ cols }} from 1 for 3) as hash_alg_{{ cols }},
        CASE
            WHEN end_position_{{ cols }} > 0
            THEN SUBSTRING({{ cols }} from start_position_{{ cols }} for end_position_{{ cols }}-start_position_{{ cols }})
            ELSE  {{ cols }}
        END as {{ cols}},
        {%- endfor %}
        {%- for cols in payload_columns|map('lower') %}
        {{ cols }}
        {%- if not loop.last %},{%- endif -%}
        {%- endfor %}
    FROM positions
),

final as (
    SELECT
        {%- for cols in hashed_columns|map('lower') %}
        case
            when
                lower(hash_alg_{{ cols }}) = 'md5'
                then DECODE(MD5({{ cols }}), 'hex')
            when
                lower(hash_alg_{{ cols }}) = 'sha'
                then SHA256(CAST({{ cols }} AS BYTEA))
            else CAST({{ cols }} AS BYTEA)
        end as {{ cols }},
        {%- endfor %}
        {%- for cols in payload_columns|map('lower') %}
        {{ cols }}
        {%- if not loop.last %},{%- endif -%}
        {%- endfor %}
    FROM hashing_string
)

SELECT * FROM final

{%- endmacro -%}

