{%- macro duckdb__sat(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}




{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source]) -%}

{%- set rank_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}

{%- set pk_cols = automate_dv.expand_column_list(columns=[src_pk]) -%}




{%- if model.config.materialized == 'vault_insert_by_rank' %}

    {%- set source_cols_with_rank = source_cols + automate_dv.escape_column_names([config.get('rank_column')]) -%}

{%- endif -%}




{{ automate_dv.prepend_generated_by() }}




WITH source_data AS (

    {%- if model.config.materialized == 'vault_insert_by_rank' %}

    SELECT {{ automate_dv.prefix(source_cols_with_rank, 'a', alias_target='source') }}

    {%- else %}

    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='source') }}

    {%- endif %}

    FROM {{ ref(source_model) }} AS a

    WHERE {{ automate_dv.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}

    {%- if model.config.materialized == 'vault_insert_by_period' %}

    AND __PERIOD_FILTER__

    {% elif model.config.materialized == 'vault_insert_by_rank' %}

    AND __RANK_FILTER__

    {% endif %}

),




{%- if automate_dv.is_any_incremental() %}




latest_records AS (

    SELECT {{ automate_dv.prefix(rank_cols, 'a', alias_target='target') }}

    FROM (

        SELECT {{ automate_dv.prefix(rank_cols, 'current_records', alias_target='target') }},

            RANK() OVER (

                PARTITION BY {{ automate_dv.prefix([src_pk], 'current_records') }}

                ORDER BY {{ automate_dv.prefix([src_ldts], 'current_records') }} DESC

            ) AS rank

        FROM {{ this }} AS current_records

            JOIN (

                SELECT DISTINCT {{ automate_dv.prefix([src_pk], 'source_data') }}

                FROM source_data

            ) AS source_records

                ON {{ automate_dv.multikey(src_pk, prefix=['current_records','source_records'], condition='=') }}

    ) AS a

    WHERE a.rank = 1

),




{%- endif %}




records_to_insert AS (

    SELECT DISTINCT {{ automate_dv.alias_all(source_cols, 'stage') }}

    FROM source_data AS stage

    {%- if automate_dv.is_any_incremental() %}

        LEFT JOIN latest_records

            ON {{ automate_dv.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}

            WHERE {{ automate_dv.prefix([src_hashdiff], 'latest_records', alias_target='target') }} != {{ automate_dv.prefix([src_hashdiff], 'stage') }}

                OR {{ automate_dv.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL

    {%- endif %}

)




SELECT * FROM records_to_insert




{%- endmacro -%}