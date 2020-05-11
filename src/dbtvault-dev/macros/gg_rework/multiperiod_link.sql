{%- macro multiperiod_link(src_pk, src_fk, src_ldts, src_source,
               source) -%}
{%- set source_data = dbtvault.is_multi_source(source, src_pk, src_fk, src_ldts, src_source) -%}
{%- set source_col = source_data[0] -%}
{%- set is_union = source_data[1] -%}
SELECT {{ dbtvault.prefix([src_pk, src_fk, src_ldts, src_source], 'stg') }}
FROM
(
    SELECT ROW_NUMBER()
    OVER (PARTITION BY b.{{ src_pk }}
    ORDER BY {{ dbtvault.prefix([src_ldts, src_source], 'b') }}) AS RowNum,
    {{ dbtvault.prefix([src_pk, src_fk, src_ldts, src_source], 'b') }}
    FROM (
        {{ source_col }}
    ) AS b
    {%- if not is_incremental() %}
        {% if is_union %}
            WHERE b.FIRST_SOURCE IS NULL
            {%- for fk in src_fk %}
            AND {{ dbtvault.prefix([fk], 'b') }}<>{{ dbtvault.hash_check("'^^'") }}
            {% endfor %}
        {% else -%}
            WHERE
            {%- for fk in src_fk %}
                {{ dbtvault.prefix([fk], 'b') }}<>{{ dbtvault.hash_check("'^^'") }}
                {%- if not loop.last %} AND {%- endif -%}
            {%- endfor -%}
        {%- endif -%}
    {% endif %}
) AS stg
{# If incremental union or single #}
{%- if is_incremental() -%}
LEFT JOIN {{ this }} AS tgt
ON {{ dbtvault.prefix([src_pk], 'stg') }} = {{ dbtvault.prefix([src_pk], 'tgt') }}
WHERE {{ dbtvault.prefix([src_pk], 'tgt') }} IS NULL
AND stg.RowNum = 1
{% else %}
    WHERE stg.RowNum = 1
{%- endif -%}
{% for fk in src_fk -%}
    AND {{ dbtvault.prefix([fk], 'stg') }} <> {{ dbtvault.hash_check("''") }}
{% endfor -%}
{% for fk in src_fk -%}
    AND {{ dbtvault.prefix([fk], 'stg') }} <> {{ dbtvault.hash_check("'^^'") }}
{% endfor %}
{%- endmacro -%}