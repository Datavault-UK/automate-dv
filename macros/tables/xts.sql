{%- macro xts(src_pk, src_satellite, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('xts', packages = var('adapter_packages', ['dbtvault']))(src_pk=src_pk,
                                                                                  src_satellite=src_satellite,
                                                                                  src_ldts=src_ldts,
                                                                                  src_source=src_source,
                                                                                  source_model=source_model) -}}

{%- endmacro %}

{%- macro default__xts(src_pk, src_satellite, src_ldts, src_source, source_model) -%}

{{ dbtvault.prepend_generated_by() }}

{{ 'WITH ' }}
{% for satellite_name in src_satellite["SATELLITE_NAME"] -%}
{%- set hashdiff = src_satellite["SATELLITE_NAME"][satellite_name]["HASHDIFF"] -%}
{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, satellite_name, hashdiff, src_ldts, src_source]) -%}

rank_{{ satellite_name }} AS (
    SELECT {{ source_cols | join(', ') }},
        ROW_NUMBER() OVER(
            PARTITION BY {{ src_pk }}
            ORDER BY {{ src_ldts }} ASC
        ) AS row_number
    FROM {{ ref(source_model) }}
),
stage_{{ satellite_name }} AS (
    SELECT DISTINCT {{ source_cols | join(', ')}}
    FROM rank_{{ satellite_name }}
    WHERE row_number = 1
),
{% endfor -%}

stage_union AS (
    {%- for satellite_name in src_satellite["SATELLITE_NAME"] %}
    SELECT * FROM stage_{{ satellite_name }}
    {%- if not loop.last %}
    UNION ALL
    {%- endif %}
    {%- endfor %}
),
records_to_insert AS (
    SELECT stage_union.* FROM stage_union
    LEFT JOIN {{ this }} AS d
    ON stage.{{ src_pk }} = d.{{ src_pk }}
    WHERE {{ dbtvault.prefix([src_pk], 'd') }} IS NULL
)

SELECT * FROM records_to_insert

{%- endmacro -%}