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
{% for satellite_name in src_satellite['SATELLITE_NAME'] -%}
{# these variables agree with the vault_structure columns in the yaml. However the seedconfig has no such format #}
{%- set hashdiff = src_satellite['HASHDIFF'][loop.index - 1] + ' AS HASHDIFF'-%}
{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, hashdiff, satellite_name + ' AS SATELLITE_NAME', src_ldts, src_source]) -%}

satellite_{{ satellite_name }} AS (
    SELECT {{ source_cols | join(', ') }}
    FROM {{ ref(source_model) }}
),
{% endfor -%}

union_satellites AS (
    {%- for satellite_name in src_satellite["SATELLITE_NAME"] %}
    SELECT * FROM satellite_{{ satellite_name }}
    {%- if not loop.last %}
    UNION ALL
    {%- endif %}
    {%- endfor %}
),
records_to_insert AS (
    SELECT union_satellites.* FROM union_satellites
    {%- if dbtvault.is_vault_insert_by_period() or is_incremental() %}
    LEFT JOIN {{ this }} AS d
    ON union_satellites.{{ src_pk }} = d.{{ src_pk }}
    WHERE {{ dbtvault.prefix([src_pk], 'd') }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}