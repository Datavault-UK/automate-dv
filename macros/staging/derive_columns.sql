{%- macro derive_columns(source_relation=none, columns=none) -%}

    {{- adapter.dispatch('derive_columns', 'dbtvault')(source_relation=source_relation, columns=columns) -}}

{%- endmacro %}

{%- macro default__derive_columns(source_relation=none, columns=none) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}
{%- set src_columns = [] -%}
{%- set der_columns = [] -%}

{%- set source_cols = dbtvault.source_columns(source_relation=source_relation) -%}

{%- if columns is mapping and columns is not none -%}

    {#- Add aliases of derived columns to excludes and full SQL to includes -#}
    {%- for col in columns -%}

        {%- if dbtvault.is_list(columns[col]) -%}
            {%- set column_list = [] -%}

            {%- for concat_component in columns[col] -%}
                {%- set column_str = dbtvault.as_constant(concat_component) -%}
                {%- do column_list.append(column_str) -%}
            {%- endfor -%}
            {%- set concat = dbtvault.concat_ws(column_list, "||") -%}
            {%- set concat_string = concat ~ " AS " ~ dbtvault.escape_column_names(col) -%}

            {% set concat_string = "CONCAT_WS(" ~ "'||', " ~ column_list | join(", ") ~ ") AS " ~ col %}

            {%- do der_columns.append(concat_string) -%}
            {%- set exclude_columns = exclude_columns + columns[col] -%}
        {% else %}
            {%- set column_str = dbtvault.as_constant(columns[col]) -%}
            {%- do der_columns.append(column_str ~ " AS " ~ dbtvault.escape_column_names(col)) -%}
            {%- do exclude_columns.append(col) -%}
        {% endif %}

    {%- endfor -%}

    {#- Add all columns from source_model relation -#}
    {%- if source_relation is defined and source_relation is not none -%}

        {%- for col in source_cols -%}
            {%- if col not in exclude_columns -%}
                {%- do src_columns.append(dbtvault.escape_column_names(col)) -%}
            {%- endif -%}
        {%- endfor -%}

    {%- endif -%}

    {#- Makes sure the columns are appended in a logical order. Source columns then derived columns -#}
    {%- set include_columns = src_columns + der_columns -%}

    {#- Print out all columns in includes -#}
    {%- for col in include_columns -%}
        {{- col | indent(4) -}}{{ ",\n" if not loop.last }}
    {%- endfor -%}

{%- else -%}

{%- if execute -%}
{{ exceptions.raise_compiler_error("Invalid column configuration:
expected format: {'source_relation': Relation, 'columns': {column_name: column_value}}
got: {'source_relation': " ~ source_relation ~ ", 'columns': " ~ columns ~ "}") }}
{%- endif %}

{%- endif %}

{%- endmacro -%}