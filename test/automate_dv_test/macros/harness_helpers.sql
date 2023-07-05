{%- macro check_table_exists(model_name) -%}

    {%- set source_relation = adapter.get_relation(database=target.database,
                                                   schema=automate_dv_test.get_schema_name(),
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
        {%- set schema_name = automate_dv_test.get_schema_name() %}
    {%- endif -%}

    {%- set schema_relation = api.Relation.create(database=target.database, schema=schema_name) -%}

    {%- do adapter.drop_schema(schema_relation) -%}
    {%- do adapter.create_schema(schema_relation) -%}

{%- endmacro -%}


{% macro hash_database_table(model_name, unhashed_table_name, hashed_columns, payload_columns) -%}

    {%- set enable_ghost_record = var('enable_ghost_records', false) -%}

    {%- set hash_cols = [] -%}
    {%- set payload_cols_casting = [] -%}
    {%- set payload_strings = [] -%}
    {%- set payload_dates = [] -%}
    {%- set date_type = ['DATE', 'DATETIME', 'TIMESTAMPTZ'] -%}

    {%- for cols in hashed_columns -%}
        {%- set hash_str = dbtvault.escape_column_name(cols) -%}
        {%- do hash_cols.append("{} AS {}".format(hash_str, cols|lower)) -%}
    {%- endfor -%}

    {%- for cols in payload_columns -%}
        {%- set payload_str = dbtvault.escape_column_name(cols[0]) -%}
        {%- set payload_type = cols[1] -%}
        {%- do payload_cols_casting.append("{}::{} AS {}".format(payload_str, payload_type, payload_str|lower)) -%}
        {%- if payload_type is in date_type -%}
            {%- do payload_dates.append(cols[0]) -%}
        {%- else -%}
            {%- do payload_strings.append(cols[0]) -%}
        {%- endif -%}
    {%- endfor -%}

WITH core_table AS (
    SELECT
        {%- for col in hash_cols %}
        {{ col }},
        {%- endfor -%}
        {%- for col in payload_cols_casting %}
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
        {%- for cols in payload_dates|map('lower') %}
        {{ cols }},
        {%- endfor %}
        {%- for cols in payload_strings|map('lower') %}
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
        {%- if enable_ghost_record %} ELSE {{ cols }} {%- endif %}
        END as {{ cols}},
        {%- endfor %}
        {%- for cols in payload_dates|map('lower') %}
        {{ cols }},
        {%- endfor %}
        {%- for cols in payload_strings|map('lower') %}
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
            {%- if enable_ghost_record %} else CAST({{ cols }} AS BYTEA) {%- endif %}
        end as {{ cols }},
        {%- endfor %}
        {%- for cols in payload_dates|map('lower') %}
        {{ cols }},
        {%- endfor %}
        {%- for cols in payload_strings|map('lower') %}
        NULLIF({{ cols }}, '') AS {{ cols }}
        {%- if not loop.last %},{%- endif -%}
        {%- endfor %}
    FROM hashing_string
)

SELECT * FROM final

{%- endmacro -%}

