{%- macro xts(src_pk, src_satellite, src_extra_columns, src_ldts, src_source, source_model) -%}

    {{- dbtvault.check_required_parameters(src_pk=src_pk, src_satellite=src_satellite,
                                           src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
    {%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
    {%- set src_extra_columns = dbtvault.escape_column_names(src_extra_columns) -%}
    {%- set src_source = dbtvault.escape_column_names(src_source) -%}

    {%- if not dbtvault.is_list(source_model) -%}
        {%- set source_model = [source_model] -%}
    {%- endif -%}

    {{ dbtvault.prepend_generated_by() }}

    {{ adapter.dispatch('xts', 'dbtvault')(src_pk=src_pk,
                                            src_satellite=src_satellite,
                                            src_extra_columns=src_extra_columns,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__xts(src_pk, src_satellite, src_extra_columns, src_ldts, src_source, source_model) -%}

{%- set hashdiff_escaped = dbtvault.escape_column_names('HASHDIFF') -%}
{%- set satellite_name_escaped = dbtvault.escape_column_names('SATELLITE_NAME') %}
{%- set satellite_count = src_satellite.keys() | list | length %}
{%- set stage_count = source_model | length %}

{%- if execute -%}
    {%- do dbt_utils.log_info('Loading {} from {} source(s) and {} satellite(s)'.format("{}.{}.{}".format(this.database, this.schema, this.identifier),
                                                                                       stage_count, satellite_count)) -%}
{%- endif %}

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
           {%- if dbtvault.is_something(src_extra_columns) -%}
               {{ dbtvault.prefix([src_extra_columns], 's') }},
           {%- endif %}
           s.{{ src_ldts }},
           s.{{ src_source }}
    FROM {{ ref(src) }} AS s
    WHERE {{ dbtvault.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}
),

    {%- set ns.last_cte = cte_name %}
    {%- endfor %}
{%- endfor %}

{%- if stage_count > 1 or satellite_count > 1 %}

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
{%- set ns.last_cte = "union_satellites" -%}
{%- endif %}

records_to_insert AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], 'a') }},
        a.{{ hashdiff_escaped }},
        a.{{ satellite_name_escaped }} ,
        {%- if dbtvault.is_something(src_extra_columns) -%}
            {{ dbtvault.prefix([src_extra_columns], 'a') }},
        {%- endif %}
        a.{{ src_ldts }},
        a.{{ src_source }}
    FROM {{ ns.last_cte }} AS a
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN {{ this }} AS d
        ON (
            a.{{ hashdiff_escaped }} = d.{{ hashdiff_escaped }}
            AND a.{{ src_ldts }} = d.{{ src_ldts }}
            AND a.{{ satellite_name_escaped }} = d.{{ satellite_name_escaped }}
        )
    WHERE d.{{ hashdiff_escaped }} IS NULL
    AND d.{{ src_ldts }} IS NULL
    AND d.{{ satellite_name_escaped }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
