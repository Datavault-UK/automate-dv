{%- macro xts(src_pk, src_satellite, src_ldts, src_source, source_model) -%}
    {{- adapter.dispatch('xts', 'dbtvault')(src_pk=src_pk,
                                            src_satellite=src_satellite,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__xts(src_pk, src_satellite, src_ldts, src_source, source_model) -%}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_names(src_source) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif %}

{{ 'WITH ' }}
{%- for src in source_model %}
    {%- for satellite in src_satellite.items() -%}
        {%- set satellite_name = (satellite[1]['sat_name'].values() | list) [0] -%}
        {%- set hashdiff = (satellite[1]['hashdiff'].values() | list) [0] %}

        satellite_{{ satellite_name }}_from_{{ src }} AS (
            SELECT {{ dbtvault.prefix([src_pk], 's') }}, s.{{ dbtvault.escape_column_names(hashdiff) }} AS HASHDIFF, s.{{ dbtvault.escape_column_names(satellite_name) }} AS SATELLITE_NAME, s.{{ src_ldts }}, s.{{ src_source }}
            FROM {{ ref(src) }} AS s
            WHERE {{ dbtvault.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}
        ),
    {%- endfor %}
{%- endfor %}

union_satellites AS (
    {%- for src in source_model %}
        {%- for satellite in src_satellite.items() %}
    SELECT * FROM satellite_{{ (satellite[1]['sat_name'].values() | list) [0] }}_from_{{ src }}
            {%- if not loop.last %}
    UNION ALL
            {%- endif %}
        {%- endfor %}
        {%- if not loop.last %}
    UNION ALL
        {%- endif %}
    {%- endfor %}
),

records_to_insert AS (
    SELECT DISTINCT union_satellites.* FROM union_satellites
    {%- if dbtvault.is_vault_insert_by_period() or is_incremental() %}
    LEFT JOIN {{ this }} AS d
    ON (union_satellites.{{ 'HASHDIFF' }} = d.{{ 'HASHDIFF' }}
        AND union_satellites.{{ src_ldts }} = d.{{ src_ldts }}
        AND union_satellites.{{ 'SATELLITE_NAME' }} = d.{{ 'SATELLITE_NAME' }}
    )
    WHERE {{ dbtvault.prefix(['HASHDIFF'], 'd') }} IS NULL
    AND {{ dbtvault.prefix([ src_ldts ], 'd') }} IS NULL
    AND {{ dbtvault.prefix([ 'SATELLITE_NAME' ], 'd') }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
