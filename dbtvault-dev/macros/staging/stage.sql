{%- macro stage(include_source_columns=none, source_model=none, hashed_columns=none, derived_columns=none, ranked_columns=none) -%}

    {% if include_source_columns is none %}
        {%- set include_source_columns = true -%}
    {% endif %}

    {{- adapter.dispatch('stage', packages = dbtvault.get_dbtvault_namespaces())(include_source_columns=include_source_columns,
                                                                                 source_model=source_model,
                                                                                 hashed_columns=hashed_columns,
                                                                                 derived_columns=derived_columns,
                                                                                 ranked_columns=ranked_columns) -}}
{%- endmacro -%}

{%- macro default__stage(include_source_columns, source_model, hashed_columns, derived_columns, ranked_columns) -%}

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
    {%- set all_source_columns = dbtvault.source_columns(source_relation=source_relation) -%}
{%- elif source_model is not mapping and source_model is not none -%}

    {%- set source_relation = ref(source_model) -%}
    {%- set all_source_columns = dbtvault.source_columns(source_relation=source_relation) -%}
{%- endif -%}

{%- set derived_column_names = dbtvault.extract_column_names(derived_columns) -%}
{%- set exclude_column_names = derived_column_names + dbtvault.extract_column_names(hashed_columns) %}

{%- set source_columns_to_select = dbtvault.process_columns_to_select(all_source_columns, exclude_column_names) -%}

{#- CTE to add source columns from the source model -#}
WITH stage AS (
    SELECT *
    FROM {{ source_relation }}
),

{# Derive additional columns, if provided, and carry over source columns from previous CTE for use in the hash stage -#}
derived_columns AS (
    SELECT
    {#- Re-factor to avoid so many IF statements -#}
    {{- " *" if dbtvault.is_nothing(derived_columns) and dbtvault.is_nothing(hashed_columns) and include_source_columns -}}
    {{- " *" if dbtvault.is_nothing(derived_columns) and not include_source_columns -}}

    {%- if include_source_columns and dbtvault.is_something(derived_columns) -%}

        {{ "\n\n" ~ dbtvault.derive_columns(source_relation=source_relation, columns=derived_columns) | indent(4, first=true) -}}
    {%- elif not include_source_columns and dbtvault.is_nothing(hashed_columns) and dbtvault.is_something(derived_columns) -%}

        {{ "\n\n" ~ dbtvault.derive_columns(columns=derived_columns) | indent(4, first=true) -}}
    {%- elif include_source_columns and dbtvault.is_nothing(derived_columns) and dbtvault.is_something(hashed_columns) -%}

        {{- dbtvault.print_list(all_source_columns, trailing_comma=false) -}}
    {%- elif not include_source_columns and dbtvault.is_something(derived_columns) and dbtvault.is_something(hashed_columns) -%}

        {{ "\n\n" ~ dbtvault.derive_columns(source_relation=source_relation, columns=derived_columns) | indent(4, first=true) -}}
    {%- endif %}

    FROM stage
),

{# Hash columns, if provided, and process exclusion flags if provided -#}
hashed_columns AS (
    SELECT

    {{- " *" if dbtvault.is_something(ranked_columns) and dbtvault.is_nothing(hashed_columns) and not include_source_columns -}}
    {{- " *" if dbtvault.is_something(derived_columns) and dbtvault.is_nothing(hashed_columns) -}}

    {%- set derived_and_source = source_columns_to_select + derived_column_names -%}

    {#- Re-factor to avoid so many IF statements -#}
    {%- if include_source_columns and dbtvault.is_something(derived_columns) and dbtvault.is_something(hashed_columns) %}

        {{- dbtvault.print_list(derived_and_source, trailing_comma=true) -}}
    {%- elif not include_source_columns and dbtvault.is_something(derived_columns) and dbtvault.is_something(hashed_columns) %}

        {{- dbtvault.print_list(derived_column_names, trailing_comma=true) -}}
    {%- elif include_source_columns and dbtvault.is_nothing(derived_columns) and dbtvault.is_nothing(hashed_columns) %}

        {{- dbtvault.print_list(all_source_columns, trailing_comma=false) -}}
    {%- elif include_source_columns and dbtvault.is_nothing(derived_columns) and dbtvault.is_something(hashed_columns) -%}

        {{- dbtvault.print_list(source_columns_to_select, trailing_comma=true) -}}
    {%- endif %}

    {%- if dbtvault.is_something(hashed_columns) -%}
        {%- set processed_hash_columns = dbtvault.process_hash_column_excludes(hashed_columns, all_source_columns) -%}
        {{- "\n\n" ~ dbtvault.hash_columns(columns=processed_hash_columns) | indent(4, first=true) -}}
    {%- endif %}

    FROM derived_columns
),

{# Add ranked columns if provided -#}
ranked_columns AS (

    SELECT  {{- " *,\n\n" if dbtvault.is_something(ranked_columns) else " *" -}}

    {{ dbtvault.rank_columns(columns=ranked_columns) | indent(4, first=true) if dbtvault.is_something(ranked_columns) }}

    FROM hashed_columns

)

SELECT * FROM ranked_columns
{%- endmacro -%}