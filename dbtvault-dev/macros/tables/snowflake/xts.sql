{%- macro xts(src_pk, src_satellite, src_additional_columns, src_ldts, src_source, source_model) -%}

    {{- dbtvault.check_required_parameters(src_pk=src_pk, src_satellite=src_satellite,
                                           src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
    {%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
    {%- set src_additional_columns = dbtvault.escape_column_names(src_additional_columns) -%}
    {%- set src_source = dbtvault.escape_column_names(src_source) -%}

    {{- adapter.dispatch('xts', 'dbtvault')(src_pk=src_pk,
                                            src_satellite=src_satellite,
                                            src_additional_columns=src_additional_columns,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__xts(src_pk, src_satellite, src_additional_columns, src_ldts, src_source, source_model) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif %}

{%- set hashdiff_escaped = dbtvault.escape_column_names('HASHDIFF') -%}
{%- set satellite_name_escaped = dbtvault.escape_column_names('SATELLITE_NAME') %}

{%- set ns = namespace(last_cte= "") %}

{{ 'WITH ' }}
{%- for src in source_model -%}
    {%- for satellite in src_satellite.items() -%}
        {%- set satellite_name = (satellite[1]['sat_name'].values() | list)[0] -%}
        {%- set hashdiff = (satellite[1]['hashdiff'].values() | list)[0] %}
        {%- set cte_name = "satellite_{}_from_{}".format(satellite_name, src) | lower %}

        {{ cte_name }} AS (
            SELECT {{ dbtvault.prefix([src_pk], 's') }},
                   s.{{ dbtvault.escape_column_names(hashdiff) }} AS {{ hashdiff_escaped }},
                   s.{{ dbtvault.escape_column_names(satellite_name) }} AS {{ satellite_name_escaped }},
                   {{ dbtvault.prefix([src_additional_columns], 's') }},
                   s.{{ src_ldts }},
                   s.{{ src_source }}
            FROM {{ ref(src) }} AS s
            WHERE {{ dbtvault.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}
        ),
    {%- set ns.last_cte = cte_name %}
    {%- endfor %}
{%- endfor %}

{% if src_satellite.items() | list | length > 1 %}

union_satellites AS (
    {%- for src in source_model %}
        {%- for satellite in src_satellite.items() %}
            {%- set satellite_name = (satellite[1]['sat_name'].values() | list)[0]  %}
            {%- set cte_name = "satellite_{}_from_{}".format(satellite_name, src) | lower %}
    SELECT * FROM {{ cte_name }}
            {%- if not loop.last %}
    UNION ALL
            {%- endif %}
        {%- endfor %}
        {%- if not loop.last %}
    UNION ALL
        {%- endif %}
    {%- endfor %}
),
{%- set ns.last_cte = "union_satellites" %}
{% endif %}

records_to_insert AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], ns.last_cte) }},
        {{ ns.last_cte }}.{{ hashdiff_escaped }},
        {{ ns.last_cte }}.{{ satellite_name_escaped }} ,
        {{ dbtvault.prefix([src_additional_columns], ns.last_cte) }},
        {{ ns.last_cte }}.{{ src_ldts }},
        {{ ns.last_cte }}.{{ src_source }}
    FROM {{ ns.last_cte }}
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN {{ this }} AS d
        ON (
            {{ ns.last_cte }}.{{ hashdiff_escaped }} = d.{{ hashdiff_escaped }}
            AND {{ ns.last_cte }}.{{ src_ldts }} = d.{{ src_ldts }}
            AND {{ ns.last_cte }}.{{ satellite_name_escaped }} = d.{{ satellite_name_escaped }}
        )
    WHERE d.{{ hashdiff_escaped }} IS NULL
    AND d.{{ src_ldts }} IS NULL
    AND d.{{ satellite_name_escaped }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
