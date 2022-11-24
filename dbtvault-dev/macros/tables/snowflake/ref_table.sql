{%- macro ref_table(src_pk, src_extra_columns, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
    {%- set src_extra_columns = dbtvault.escape_column_names(src_extra_columns) -%}
    {%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
    {%- set src_source = dbtvault.escape_column_names(src_source) -%}

    {%- if not dbtvault.is_list(source_model) -%}
        {%- set source_model = [source_model] -%}
    {%- endif -%}

    {{ dbtvault.log_relation_sources(this, source_model | length) }}

    {{- dbtvault.prepend_generated_by() -}}

    {{- adapter.dispatch('ref_table', 'dbtvault')(src_pk=src_pk, src_extra_columns=src_extra_columns,
                                            src_ldts=src_ldts, src_source=src_source,
                                            source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__ref_table(src_pk, src_extra_columns, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_extra_columns, src_ldts, src_source]) -%}

    WITH non_historized AS (
        SELECT
            {{ src_pk }},
            {%- for ref_col in src_extra_columns %}
                {{ ref_col }},
            {% endfor %}
            {{ src_source }},
            {{ src_ldts}}
        FROM {{ source_model }}
    )

    SELECT * FROM non_historized

{%- endmacro -%}