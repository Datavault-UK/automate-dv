{%- macro stage(include_source_columns=none, source_model=none, hashed_columns=none, derived_columns=none) -%}

    {% if include_source_columns is none %}
        {%- set include_source_columns = true -%}
    {% endif %}

    {{- adapter.dispatch('stage', packages = var('adapter_packages', ['dbtvault']))(include_source_columns=include_source_columns, source_model=source_model, hashed_columns=hashed_columns, derived_columns=derived_columns) -}}
{%- endmacro -%}

{%- macro default__stage(include_source_columns, source_model, hashed_columns, derived_columns) -%}

{%- do log("-----------------------" ~ this.identifier ~ "-----------------------" , true) -%}

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

{%- set derived_column_names = dbtvault.extract_column_names(derived_columns) -%}
{%- set hashed_column_names = dbtvault.extract_column_names(hashed_columns) -%}
{%- set exclude_column_names = derived_column_names + hashed_column_names %}

{%- do log("[stage]: derived_column_names: " ~ derived_column_names, true) -%}
{%- do log("[stage]: hashed_column_names: " ~ hashed_column_names, true) -%}
{%- do log("[stage]: exclude_column_names: " ~ exclude_column_names, true) -%}
{%- do log("[stage]: included_source_columns: " ~ included_source_columns, true) -%}

{%- set columns_to_select = dbtvault.process_columns_to_select(included_source_columns, exclude_column_names) -%}

{#- CTE to add source columns from the source model -#}
WITH stage AS (
    SELECT *
    FROM {{ source_relation }}
),

{# Derive additional columns, if provided, and carry over source columns from previous CTE for use in the hash stage -#}
derived_columns AS (
    SELECT

    {%- if include_source_columns -%}
        {{- "\n\n    " -}}
        {{- (columns_to_select | join(",\n")) | indent(4) -}},
    {%- else -%}
        {{- "\n" -}}
    {%- endif -%}

    {%- if dbtvault.is_something(derived_columns) -%}
        {{- ("\n" ~ dbtvault.derive_columns(columns=derived_columns)) | indent(4) -}}
    {%- endif %}

    FROM stage
),

{# Hash columns, if provided, and process exclusion flags if provided -#}
hashed_columns AS (
    SELECT

    {%- if dbtvault.is_something(derived_columns) or include_source_columns -%}
        {{- " *" -}}
    {%- endif %}

    {{- ",\n\n" if dbtvault.is_something(hashed_columns) -}}

    {{- (derived_column_names | join(",\n")) | indent(4f) if dbtvault.is_something(derived_columns) -}},

    {{- ("\n" ~ dbtvault.hash_columns(columns=hashed_columns)) | indent(4) }}

    FROM derived_columns
)

SELECT * FROM hashed_columns
{%- endmacro -%}