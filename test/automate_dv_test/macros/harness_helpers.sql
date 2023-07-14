{%- macro check_table_exists(model_name) -%}

    {%- set source_relation = adapter.get_relation(database=target.database,
                                                   schema=automate_dv_test.get_schema_name(),
                                                   identifier=model_name) -%}

    {%- if source_relation -%}
        {%- do log("Table '{}' exists.".format(model_name), true) -%}
        {%- do log("Fully qualified name: {}".format(source_relation), true) -%}
        {%- do return(True) %}
    {%- else -%}
        {%- do log("Table '{}' does not exist.".format(model_name), true) -%}
        {%- do return(False) %}
    {%- endif -%}

    {%- do return(False) %}

{%- endmacro -%}


{% macro hash_database_table(model_name, unhashed_table_name, hashed_columns, payload_columns) -%}

    {%- set enable_ghost_record = var('enable_ghost_records', false) -%}

    {%- set hash_cols = [] -%}
    {%- set payload_cols_casting = [] -%}
    {%- set payload_strings = [] -%}
    {%- set payload_dates = [] -%}
    {%- set date_type = ['DATE', 'DATETIME', 'TIMESTAMPTZ'] -%}

    {%- for cols in hashed_columns -%}
        {%- set hash_str = automate_dv.escape_column_name(cols) -%}
        {%- do hash_cols.append("{} AS {}".format(hash_str, cols|lower)) -%}
    {%- endfor -%}

    {%- for cols in payload_columns -%}
        {%- set payload_str = automate_dv.escape_column_name(cols[0]) -%}
        {%- set payload_type = cols[1] -%}
        {%- do payload_cols_casting.append("NULLIF({}, '')::{} AS {}".format(payload_str, payload_type, payload_str|lower)) -%}
        {%- if payload_type is in date_type -%}
            {%- do payload_dates.append(cols[0]) -%}
        {%- else -%}
            {%- do payload_strings.append(cols[0]) -%}
        {%- endif -%}
    {%- endfor -%}

WITH core_table AS (
    SELECT
        {%- set cols_to_print = hash_cols + payload_cols_casting -%}

        {%- for col in cols_to_print %}
        {{ col }}
        {%- if not loop.last -%},{%- endif %}
        {% endfor -%}

    FROM "{{ get_schema_name() }}"."{{ unhashed_table_name }}"
),

positions as (
    SELECT
        {%- set cols_to_print = [] -%}

        {%- for col in hashed_columns|map('lower') -%}
                    {%- do cols_to_print.append("POSITION('(' in {}) + 2 as start_position_{}".format(col, col)) -%}
                    {%- do cols_to_print.append("POSITION(')' in {}) - 1 as end_position_{}".format(col, col)) -%}
        {%- endfor %}

        {%- set cols_to_print = cols_to_print + (hashed_columns|map('lower') | list) + (payload_dates|map('lower') | list) + (payload_strings|map('lower') | list) -%}

        {% for col in cols_to_print %}
        {{ col }}
        {%- if not loop.last -%},{%- endif %}
        {% endfor -%}

    FROM core_table
),

hashing_string as (
    SELECT

        {%- set cols_to_print = (payload_dates|map('lower') | list) + (payload_strings|map('lower') | list) -%}

        {%- for col in hashed_columns|map('lower') -%}
        {%- set hashed_col -%}
        SUBSTRING({{ col }} from 1 for 3) as hash_alg_{{ col }},
        CASE
            WHEN end_position_{{ col }} > 0
            THEN SUBSTRING({{ col }} from start_position_{{ col }} for end_position_{{ col }}-start_position_{{ col }})
        ELSE {{ col }}
        END as {{ col }}
        {%- endset -%}

        {%- do cols_to_print.append(hashed_col) -%}

        {%- endfor %}

        {% for col in cols_to_print %}
        {{ col }}
        {%- if not loop.last -%},{%- endif %}
        {% endfor %}

    FROM positions
),

final as (
    {%- set cols_to_print = (payload_dates|map('lower') | list) -%}

    {%- for col in payload_strings|map('lower') -%}
        {%- do cols_to_print.append("COALESCE({}, NULL) AS {}".format(col, col)) -%}
    {%- endfor -%}

    {% for col in hashed_columns|map('lower') -%}
        {%- set hashed_col -%}
        case
            when
                lower(hash_alg_{{ col }}) = 'md5'
                then DECODE(MD5({{ col }}), 'hex')
            when
                lower(hash_alg_{{ col }}) = 'sha'
                then SHA256(CAST({{ col }} AS BYTEA))
            else CAST({{ col }} AS BYTEA)
        end as {{ col }}
        {%- endset -%}

        {%- do cols_to_print.append(hashed_col) -%}
    {%- endfor %}

    SELECT

        {% for col in cols_to_print %}
        {{ col }}
        {%- if not loop.last -%},{%- endif %}
        {% endfor -%}

    FROM hashing_string
)

SELECT * FROM final

{%- endmacro -%}

