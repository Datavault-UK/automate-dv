
{%- macro bigquery__sat2(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence) -%}

{# START > ADDED BY GEORGIAN #}
{%- if out_of_sequence and execute -%}
  {{- exceptions.raise_compiler_error("Out of sequence Sats are not supported by the current version of dbtvault_bq") -}}
{%- endif -%}
{# END   > ADDED BY GEORGIAN #}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT *
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
),

{% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}

latest_sat_records_in_source AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
    WHERE 1 = 1
    QUALIFY
        1 = RANK() OVER (
            PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
            ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }} DESC
        )
),

{% endif -%}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'c') }}
    FROM source_data AS c
    {% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}
    LEFT JOIN
        latest_sat_records_in_source
    ON
        {{ dbtvault.prefix([src_hashdiff], 'latest_sat_records_in_source', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'c') }}
    WHERE
        {{ dbtvault.prefix([src_hashdiff], 'latest_sat_records_in_source', alias_target='target') }} IS NULL
    {% endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}




/*------ OVERWRITE SNOWFLAKE -----*/





/*------ OVERWRITE SNOWFLAKE -----*/

{%- macro bigquery__sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                       src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols_with_rank, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.prefix([src_pk], 'a') }} IS NOT NULL
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {% elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {% endif %}
),

{% if dbtvault.is_any_incremental() %}


latest_records AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
    WHERE 1 = 1
    QUALIFY
        1 = ROW_NUMBER() OVER (
            PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
            ORDER BY {{ dbtvault.prefix([src_eff], 'a') }} DESC
        )
),
{%- endif %}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN latest_records
    ON {{ dbtvault.prefix([src_pk], 'latest_records', alias_target='target') }} = {{ dbtvault.prefix([src_pk], 'stage') }}
    WHERE
        ({{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} != {{ dbtvault.prefix([src_hashdiff], 'stage') }}
        OR {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL)
        AND {{ dbtvault.prefix([src_eff], 'stage') }} > {{ dbtvault.prefix([src_eff], 'latest_records', alias_target='target') }}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}


/*
latest_records
--------------


SAT
hk  | ldts | ef
id1 | 3    | 1


SOURCE
hk  | ldts | ef
id1 | 9    | 2  <
id1 | 9    | 1



JOIN GOT

hk  | source.ldts | source.ef | sat.ldts | sat.ef
id1 | 9           | 2         | 3        | 1
id1 | 9           | 1         | 3        | 1

SELECT + QUALIFY:

hk  | sat.ldts | sat.ef
id1 | 3        | 1
id1 | 3        | 1

======================


JOIN WANT

id1 | 9    | 1


*/