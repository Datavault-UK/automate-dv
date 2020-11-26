{%- macro calcualte_hash_exclusions(source_relation=source_releation, derived_columns=none ,exclude_columns=none) -%}

{%- set all_columns = [] -%}
{%- set include_columns = [] -%}


{#- getting all the source collumns and derived columns -#}
{%- if derived_columns is defined and derived_columns is not none -%}
    {%- if include_source_columns or hashed_columns is defined and hashed_columns is not none %}

        {% set _ = all_columns.append(dbtvault.derive_columns(source_relation=source_relation, columns=derived_columns)) %}

    {%- else %}

        {% set _ = all_columns.append(dbtvault.derive_columns(columns=derived_columns)) %}
        {% set _ = all_columns.append(dbtvault.source_columns(source_relation=source_relation)) %}

    {%- endif -%}

{%- else -%}

    {% set _ = all_columns.append(dbtvault.source_columns(source_relation=source_relation)) %}

{%- endif -%}


{%- for col in all_columns -%}
    {%- if col not in exclude_columns -%}
        {%- set _ = include_columns.append(col) -%}
    {%- endif -%}
{%- endfor -%}

{%- do return(include_columns) -%}

{%- endmacro -%}