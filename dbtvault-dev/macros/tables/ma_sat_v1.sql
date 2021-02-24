{%- macro ma_sat_v1(src_pk, src_dk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('ma_sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_dk=src_dk, src_hashdiff=src_hashdiff,
                                                                                  src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                                                  src_source=src_source, source_model=source_model) -}}

{%- endmacro %}

{%- macro default__ma_sat_v1(src_pk, src_dk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}


{{- dbtvault.check_required_parameters(src_pk=src_pk, src_dk=src_dk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                       src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}

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
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
    {%- set source_cte = "source_data" %}
),

{%- if model.config.materialized == 'vault_insert_by_rank' %}
rank_col AS (
    SELECT * FROM source_data
    WHERE __RANK_FILTER__
    {%- set source_cte = "rank_col" %}
),
{% endif -%}

{% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}

update_records AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
),

latest_records AS (
    SELECT {{ dbtvault.prefix([src_dk], 'c', alias_target='target') }}, {{ dbtvault.prefix(rank_cols, 'c', alias_target='target') }},
           CASE WHEN RANK()
           OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'c') }}
           ORDER BY {{ dbtvault.prefix([src_ldts], 'c') }} DESC) = 1
    THEN 'Y' ELSE 'N' END AS latest
    FROM update_records as c
    QUALIFY latest = 'Y'
),

changes AS (
    SELECT DISTINCT
     COALESCE(ls."CUSTOMER_PK", stg."CUSTOMER_PK") AS "CUSTOMER_PK"
    FROM {{ source_cte }} AS stg
    FULL OUTER JOIN latest_records AS ls
    ON stg."CUSTOMER_PK" = ls."CUSTOMER_PK"
    AND stg."CUSTOMER_PHONE" = ls."CUSTOMER_PHONE"
    WHERE stg."HASHDIFF" IS null -- existent entry in ma sat not found in stage
    OR ls."HASHDIFF" IS null -- new entry in stage not found in latest set of ma sat
    OR stg."HASHDIFF" != ls."HASHDIFF" -- entry is modified
),

{%- endif %}


records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'e') }}
    FROM {{ source_cte }} AS e
    {%- if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}
    LEFT JOIN latest_records
{#    ON {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'e') }}#}
{#    WHERE {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL#}
    ON {{ dbtvault.prefix([src_pk], 'latest_records', alias_target='target') }} = {{ dbtvault.prefix([src_pk], 'e') }}
    AND {{ dbtvault.prefix([src_ldts], 'latest_records', alias_target='target') }} = {{ dbtvault.prefix([src_ldts], 'e') }}
    AND {{ dbtvault.prefix([src_dk], 'latest_records', alias_target='target') }} = {{ dbtvault.prefix([src_dk], 'e') }}
    LEFT JOIN changes
    ON {{ dbtvault.prefix([src_pk], 'changes', alias_target='target') }} = {{ dbtvault.prefix([src_pk], 'e') }}
    WHERE {{ dbtvault.prefix([src_pk], 'changes', alias_target='target') }} = {{ dbtvault.prefix([src_pk], 'e') }}
    {%- endif %}
)

SELECT * FROM records_to_insert


{%- endmacro -%}