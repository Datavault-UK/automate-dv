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
    {%- set included_source_columns = dbtvault.source_columns(source_relation=source_relation) -%}
{%- elif source_model is not mapping and source_model is not none -%}

    {%- set source_relation = ref(source_model) -%}
    {%- set included_source_columns = dbtvault.source_columns(source_relation=source_relation) -%}
{%- endif -%}

{%- set derived_column_names = dbtvault.extract_column_names() -%}
{%- set hashed_column_names = dbtvault.extract_column_names() -%}
{%- set exclude_column_names = derived_column_names + hashed_column_names %}

{%- do log("derived_column_names: " ~ derived_column_names, true) -%}
{%- do log("hashed_column_names: " ~ hashed_column_names, true) -%}
{%- do log("exclude_column_names: " ~ exclude_column_names, true) -%}
{%- do log("included_source_columns: " ~ included_source_columns, true) -%}

{%- set columns_to_select = dbtvault.process_columns_to_select(included_source_columns, exclude_column_names) -%}

{#- CTE to add source columns from the source model -#}
WITH stage AS (
    SELECT *
    FROM {{ source_relation }}
),

{# Derive additional columns, if provided, and carry over source columns from previous CTE for use in the hash stage -#}
derived_columns AS (
    SELECT

    {% if dbtvault.is_nothing(derived_columns) -%}
        {{- " *" -}}
    {#- If source relation is defined but derived_columns is not -#}
    {%- else -%}
        {%- if include_source_columns or hashed_columns is defined and hashed_columns is not none -%}

            {{- dbtvault.derive_columns(source_relation=source_relation, columns=derived_columns) | indent(width=4, first=false) -}}
        {%- else -%}

            {{- dbtvault.derive_columns(columns=derived_columns) | indent(4) -}}
        {%- endif -%}

    {%- endif %}

    FROM stage
),

{# Hash columns, if provided, and process exclusion flags if provided -#}
hashed_columns AS (
    SELECT

    {%- if dbtvault.is_nothing(hashed_columns) and dbtvault.is_something(derived_columns) -%}
        {{- " *" -}}
    {%- else -%}
        {{- "\n\n    " ~ columns_to_select | join (",\n    ") -}}

        {%- if derived_columns is defined and derived_columns is not none and include_source_columns is false -%}
            {{- dbtvault.derive_columns(columns=derived_columns) | indent(4) -}},
        {%- endif -%}

        {{- ",\n\n    " ~ dbtvault.hash_columns(columns=hashed_columns) | indent(4) -}}
    {%- endif %}

    FROM derived_columns
)

SELECT * FROM hashed_columns
{%- endmacro -%}