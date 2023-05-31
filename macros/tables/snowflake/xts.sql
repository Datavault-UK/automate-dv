/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro xts(src_pk, src_satellite, src_extra_columns, src_ldts, src_source, source_model) -%}

    {{- automate_dv.check_required_parameters(src_pk=src_pk, src_satellite=src_satellite,
                                           src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- if not automate_dv.is_list(source_model) -%}
        {%- set source_model = [source_model] -%}
    {%- endif -%}

    {{ automate_dv.prepend_generated_by() }}

    {{ adapter.dispatch('xts', 'automate_dv')(src_pk=src_pk,
                                            src_satellite=src_satellite,
                                            src_extra_columns=src_extra_columns,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__xts(src_pk, src_satellite, src_extra_columns, src_ldts, src_source, source_model) -%}

{%- set hashdiff_col_name_alias = 'HASHDIFF' -%}
{%- set satellite_name_col_name_alias = 'SATELLITE_NAME' %}
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
    SELECT {{ automate_dv.prefix([src_pk], 's') }},
           s.{{ hashdiff }} AS {{ hashdiff_col_name_alias }},
           s.{{ satellite_name }} AS {{ satellite_name_col_name_alias }},
           {%- if automate_dv.is_something(src_extra_columns) -%}
               {{ automate_dv.prefix([src_extra_columns], 's') }},
           {%- endif %}
           s.{{ src_ldts }},
           s.{{ src_source }}
    FROM {{ ref(src) }} AS s
    WHERE {{ automate_dv.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}
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
        {{ automate_dv.prefix([src_pk], 'a') }},
        a.{{ hashdiff_col_name_alias }},
        a.{{ satellite_name_col_name_alias }},
        {%- if automate_dv.is_something(src_extra_columns) -%}
            {{ automate_dv.prefix([src_extra_columns], 'a') }},
        {%- endif %}
        a.{{ src_ldts }},
        a.{{ src_source }}
    FROM {{ ns.last_cte }} AS a
    {%- if automate_dv.is_any_incremental() %}
    LEFT JOIN {{ this }} AS d
        ON (
            a.{{ hashdiff_col_name_alias }} = d.{{ hashdiff_col_name_alias }}
            AND a.{{ src_ldts }} = d.{{ src_ldts }}
            AND a.{{ satellite_name_col_name_alias }} = d.{{ satellite_name_col_name_alias }}
        )
    WHERE d.{{ hashdiff_col_name_alias }} IS NULL
    AND d.{{ src_ldts }} IS NULL
    AND d.{{ satellite_name_col_name_alias }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
