{%- macro redshift__ma_sat(
        src_pk,
        src_cdk,
        src_hashdiff,
        src_payload,
        src_extra_columns,
        src_eff,
        src_ldts,
        src_source,
        source_model
    ) -%}
    {%- set source_cols = dbtvault.expand_column_list(
        columns = [src_pk, src_cdk, src_payload, src_extra_columns, src_hashdiff, src_eff, src_ldts, src_source]
    ) -%}
    {%- set rank_cols = dbtvault.expand_column_list(
        columns = [src_pk, src_hashdiff, src_ldts]
    ) -%}
    {%- set cdk_cols = dbtvault.expand_column_list(
        columns = [src_cdk]
    ) -%}
    {%- set cols_for_latest = dbtvault.expand_column_list(
        columns = [src_pk, src_hashdiff, src_cdk, src_ldts]
    ) %}
    {%- if model.config.materialized == 'vault_insert_by_rank' -%}
        {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
    {%- endif %}

    {# Select unique source records #}
    WITH source_data AS (
        WITH internal_source_data AS (
            {%- if model.config.materialized == 'vault_insert_by_rank' %}
            SELECT
                DISTINCT {{ dbtvault.prefix(
                    source_cols_with_rank,
                    's',
                    alias_target = 'source'
                ) }}
            {%- else %}
            SELECT
                DISTINCT {{ dbtvault.prefix(
                    source_cols,
                    's',
                    alias_target = 'source'
                ) }}
            {%- endif %}

            {% if dbtvault.is_any_incremental() %},
                DENSE_RANK() over (PARTITION BY {{ dbtvault.prefix([src_pk], 's') }}
            ORDER BY
                {{ dbtvault.prefix([src_hashdiff], 's', alias_target = 'source') }}, {{ dbtvault.prefix(cdk_cols, 's', alias_target = 'source') }}) AS source_count_internal
            {% endif %}
            FROM
                {{ ref(source_model) }} AS s
            WHERE
                {{ dbtvault.multikey(
                    [src_pk],
                    prefix = 's',
                    condition = 'IS NOT NULL'
                ) }}

                {%- for child_key in cdk_cols %}
                    AND {{ dbtvault.multikey(
                        child_key,
                        prefix = 's',
                        condition = 'IS NOT NULL'
                    ) }}
                {%- endfor %}

                {%- if model.config.materialized == 'vault_insert_by_period' %}
                    AND __PERIOD_FILTER__ {%- elif model.config.materialized == 'vault_insert_by_rank' %}
                    AND __RANK_FILTER__
                {%- endif %}
        ) {%- if model.config.materialized == 'vault_insert_by_rank' %}
        SELECT
            DISTINCT {{ dbtvault.prefix(
                source_cols_with_rank,
                'isd',
                alias_target = 'source'
            ) }}
        {%- else %}
        SELECT
            DISTINCT {{ dbtvault.prefix(
                source_cols,
                'isd',
                alias_target = 'source'
            ) }}
        {%- endif %}
        {% if dbtvault.is_any_incremental() %},
        MAX(
            isd.source_count_internal
        ) over (PARTITION BY {{ dbtvault.prefix([src_pk], 'isd') }}) AS source_count
        {% endif %}
        FROM
            internal_source_data AS isd
    ),
    {# if any_incremental -#}
    {% if dbtvault.is_any_incremental() %}
        {# Select latest records from satellite, restricted to PKs in source data -#}
        latest_records AS (
            WITH inner_latest_records AS (
                SELECT
                    {{ dbtvault.prefix(
                        cols_for_latest,
                        'mas',
                        alias_target = 'target'
                    ) }},
                    mas.latest_rank,
                    DENSE_RANK() over (PARTITION BY {{ dbtvault.prefix([src_pk], 'mas') }}
                ORDER BY
                    {{ dbtvault.prefix([src_hashdiff], 'mas', alias_target = 'target') }}, {{ dbtvault.prefix(cdk_cols, 'mas') }} ASC) AS check_rank
                FROM
                    (
                        SELECT
                            {{ dbtvault.prefix(
                                cols_for_latest,
                                'inner_mas',
                                alias_target = 'target'
                            ) }},
                            RANK() over (
                                PARTITION BY {{ dbtvault.prefix(
                                    [src_pk],
                                    'inner_mas'
                                ) }}
                                ORDER BY
                                    {{ dbtvault.prefix(
                                        [src_ldts],
                                        'inner_mas'
                                    ) }} DESC
                            ) AS latest_rank
                        FROM
                            {{ this }} AS inner_mas
                            INNER JOIN (
                                SELECT
                                    DISTINCT {{ dbtvault.prefix(
                                        [src_pk],
                                        's'
                                    ) }}
                                FROM
                                    source_data AS s
                            ) AS spk
                            ON {{ dbtvault.multikey(
                                [src_pk],
                                prefix = ['inner_mas', 'spk'],
                                condition = '='
                            ) }}
                    ) AS mas
            )
            SELECT
                *
            FROM
                inner_latest_records
            WHERE
                latest_rank = 1
        ),
        {# Select summary details for each group of latest records -#}
        latest_group_details AS (
            SELECT
                {{ dbtvault.prefix(
                    [src_pk],
                    'lr'
                ) }},
                {{ dbtvault.prefix(
                    [src_ldts],
                    'lr'
                ) }},
                MAX(
                    lr.check_rank
                ) AS latest_count
            FROM
                latest_records AS lr
            GROUP BY
                {{ dbtvault.prefix(
                    [src_pk],
                    'lr'
                ) }},
                {{ dbtvault.prefix(
                    [src_ldts],
                    'lr'
                ) }}
        ),
        {# endif any_incremental -#}
    {%- endif %}

    {# Select groups of source records where at least one member does not appear in a group of latest records -#}
    {% if dbtvault.is_any_incremental() %}
    active_records AS (
        SELECT
            {{ dbtvault.prefix(
                cols_for_latest,
                'lr',
                alias_target = 'target'
            ) }},
            lg.latest_count
        FROM
            latest_records AS lr
            INNER JOIN latest_group_details AS lg
            ON {{ dbtvault.multikey(
                [src_pk],
                prefix = ['lr', 'lg'],
                condition = '='
            ) }}
            AND {{ dbtvault.prefix(
                [src_ldts],
                'lr'
            ) }} = {{ dbtvault.prefix(
                [src_ldts],
                'lg'
            ) }}
    ),
    active_records_staging AS (
        SELECT
            {{ dbtvault.alias_all(
                source_cols,
                'stage'
            ) }}
        FROM
            source_data stage
            INNER JOIN active_records
            ON {{ dbtvault.multikey(
                [src_pk],
                prefix = ['stage', 'active_records'],
                condition = '='
            ) }}
            AND {{ dbtvault.prefix(
                [src_hashdiff],
                'stage'
            ) }} = active_records.hashdiff
            AND {{ dbtvault.multikey(
                cdk_cols,
                prefix = ['stage', 'active_records'],
                condition = '='
            ) }}
            AND stage.source_count = active_records.latest_count
    ),
    {% endif %}
    records_to_insert AS (
        SELECT
            {{ dbtvault.alias_all(
                source_cols,
                'source_data'
            ) }}
        FROM
            source_data {# if any_incremental -#}
            {% if dbtvault.is_any_incremental() %}
                LEFT JOIN active_records_staging
                ON {{ dbtvault.multikey(
                    src_pk,
                    prefix = ['source_data', 'active_records_staging'],
                    condition = '='
                ) }}
                AND  {{dbtvault.prefix([src_hashdiff], 'source_data')}} = active_records_staging.hashdiff
                AND {{ dbtvault.multikey(
                    cdk_cols,
                    prefix = ['source_data', 'active_records_staging'],
                    condition = '='
                ) }}
            WHERE
                {{ dbtvault.multikey(
                    src_pk,
                    prefix = 'active_records_staging',
                    condition = 'IS NULL'
                ) }}
                AND active_records_staging.hashdiff IS NULL
                AND {{ dbtvault.multikey(
                    cdk_cols,
                    prefix = 'active_records_staging',
                    condition = 'IS NULL'
                ) }}
                {# endif any_incremental -#}
            {%- endif %}
    )
SELECT
    *
FROM
    records_to_insert
{%- endmacro -%}
