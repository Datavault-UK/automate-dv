{# BQ Customization: Adding hash_algo t #}
{%- macro stage(include_source_columns=none, source_model=none, hashed_columns=none, derived_columns=none, hash_algo=none) -%}
    {% if include_source_columns is none %}
        {%- set include_source_columns = true -%}
    {% endif %}

    {{- adapter.dispatch('stage', packages=['dbtvault_bq'])(
        include_source_columns,
        source_model,
        hashed_columns,
        derived_columns,
        hash_algo
    ) -}}
{%- endmacro -%}

{%- macro bigquery__stage(include_source_columns, source_model, hashed_columns, derived_columns, hash_algo) -%}
-- Generated by dbtvault.

{% if (source_model is none) and execute %}

    {%- set error_message -%}
    "Staging error: Missing source_model configuration. A source model name must be provided.
    e.g.
    [REF STYLE]
    source_model: model_name
    OR
    [SOURCES STYLE]
    source_model:
    source_name: source_table_name"
    {%- endset -%}

    {{- exceptions.raise_compiler_error(error_message) -}}
{%- endif -%}

SELECT

{# Create relation object from provided source_model -#}
{% if source_model is mapping and source_model is not none -%}

    {%- set source_name = source_model | first -%}
    {%- set source_table_name = source_model[source_name] -%}

    {%- set source_relation = source(source_name, source_table_name) -%}

{%- elif source_model is not mapping and source_model is not none -%}

    {%- set source_relation = ref(source_model) -%}
{%- endif -%}

{#- Hash columns, if provided -#}
{% if hashed_columns is defined and hashed_columns is not none -%}
    {# BQ Customization: Passing hash_algo to hash_columns #}
    {{ dbtvault_bq.hash_columns(hashed_columns, hash_algo) -}}
    {{ "," if derived_columns is defined and source_relation is defined and include_source_columns }}

{% endif -%}

{#- Derive additional columns, if provided -#}
{%- if derived_columns is defined and derived_columns is not none -%}

    {%- if include_source_columns -%}
    {{ dbtvault.snowflake__derive_columns(source_relation=source_relation, columns=derived_columns) }}
    {%- else -%}
    {{ dbtvault.snowflake__derive_columns(columns=derived_columns) }}
    {%- endif -%}
{#- If source relation is defined but derived_columns is not, add columns from source model. -#}
{%- elif source_relation is defined and include_source_columns is true -%}

    {{ dbtvault.snowflake__derive_columns(source_relation=source_relation) }}
{%- endif %}

FROM {{ source_relation }}

{%- endmacro -%}