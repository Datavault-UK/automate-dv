{%- macro stage(include_source_columns=none, source_model=none, hashed_columns=none, derived_columns=none) -%}

    {% if include_source_columns is none %}
        {%- set include_source_columns = true -%}
    {% endif %}

    {{- adapter.dispatch('stage', packages = var('adapter_packages', ['dbtvault']))(include_source_columns=include_source_columns, source_model=source_model, hashed_columns=hashed_columns, derived_columns=derived_columns) -}}
{%- endmacro -%}

{%- macro default__stage(include_source_columns, source_model, hashed_columns, derived_columns) -%}

{{ dbtvault.prepend_generated_by() }}

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

{#- Check for source format or ref format and create relation object from source_model -#}
{% if source_model is mapping and source_model is not none -%}

    {%- set source_name = source_model | first -%}
    {%- set source_table_name = source_model[source_name] -%}

    {%- set source_relation = source(source_name, source_table_name) -%}

{%- elif source_model is not mapping and source_model is not none -%}

    {%- set source_relation = ref(source_model) -%}
{%- endif -%}

{#- CTE to add source columns from the source model -#}
WITH stage AS (
    SELECT

{% if source_relation is defined  -%}
    {%- set included_source_columns = dbtvault.source_columns(source_relation=source_relation) -%}

    {%- for col in included_source_columns -%}
        {{ '    ' ~ col }}
        {{- ',\n' if not loop.last -}}
    {%- endfor -%}

{%- endif %}

    FROM {{ source_relation }}
),

{# Derive additional columns, if provided, and carry over source columns from previous CTE for use in the hash stage -#}
derived_columns AS (
    SElECT

    {%- if derived_columns is defined and derived_columns is not none -%}
        {%- if include_source_columns or hashed_columns is defined and hashed_columns is not none %}

    {{ dbtvault.derive_columns(source_relation=source_relation, columns=derived_columns) | indent(width=4, first=false) }}
        {%- else %}

    {{ dbtvault.derive_columns(columns=derived_columns) | indent(4) }}

        {%- endif -%}

    {#- If source relation is defined but derived_columns is not -#}
    {%- else -%}
        {{ " *" }}
    {%- endif %}

    FROM stage
),

{# Hash columns, if provided, and process exclusion flags if provided -#}
hashed_columns AS (
    SELECT

    {%- if hashed_columns is defined and hashed_columns is not none %}
        {{- " *," if include_source_columns -}}

            {%- if derived_columns is defined and derived_columns is not none and include_source_columns is false %}

    {{ dbtvault.derive_columns(columns=derived_columns) | indent(4) }},
            {%- endif %}

    {%- set hashed_columns = dbtvault.process_excludes(source_relation=source_relation, derived_columns=derived_columns, columns=hashed_columns) %}

    {{ dbtvault.hash_columns(columns=hashed_columns) | indent(4) }}

    {%- else  -%}
    {{ " *" }}
    {%- endif %}

    FROM derived_columns
)

SELECT * FROM hashed_columns
{%- endmacro -%}