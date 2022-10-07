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
    {%- for derived_column in columns -%}
        {% set column_config = columns[derived_column] %}

        {%- if dbtvault.is_list(column_config) -%}
            {%- set column_list = [] -%}

            {%- for concat_component in column_config -%}
                {%- set column_str = dbtvault.as_constant(concat_component) -%}
                {%- do column_list.append(column_str) -%}
            {%- endfor -%}

            {%- set concat = dbtvault.concat_ws(column_list, "||") -%}
            {%- set concat_string = concat ~ " AS " ~ dbtvault.escape_column_names(derived_column) -%}

            {%- do der_columns.append(concat_string) -%}
        {%- else -%}
            {%- if column_config is mapping and column_config -%}
                {%- set column_escape = column_config['escape'] -%}

                {%- if dbtvault.is_list(column_config['source_column']) -%}
                    {%- set column_list = [] -%}

                    {%- for concat_component in column_config['source_column'] -%}
                        {%- set column_str = dbtvault.as_constant(concat_component) -%}
                        {%- if column_escape is true %}
                            {%- set column_str = dbtvault.escape_column_names(column_str) -%}
                        {% endif %}
                        {%- do column_list.append(column_str) -%}
                    {%- endfor -%}

                    {%- set concat = dbtvault.concat_ws(column_list, "||") -%}
                    {%- set concat_string = concat ~ " AS " ~ dbtvault.escape_column_names(derived_column) -%}

                    {%- do der_columns.append(concat_string) -%}
                {%- else -%}
                    {%- set column_str = dbtvault.as_constant(column_config['source_column']) -%}
                    {%- if column_escape is true -%}
                        {%- do der_columns.append(dbtvault.escape_column_names(column_str) ~ " AS " ~ dbtvault.escape_column_names(derived_column)) -%}
                    {%- else -%}
                        {%- do der_columns.append(column_str ~ " AS " ~ dbtvault.escape_column_names(derived_column)) -%}
                    {%- endif -%}
                {%- endif -%}
            {%- else -%}
                {%- set column_str = dbtvault.as_constant(column_config) -%}
                {%- do der_columns.append(column_str ~ " AS " ~ dbtvault.escape_column_names(derived_column)) -%}
            {%- endif -%}
        {%- endif -%}

        {%- do exclude_columns.append(derived_column) -%}

    {%- endfor -%}

    {#- Add all columns from source_model relation -#}
    {%- if source_relation is defined and source_relation is not none -%}

        {%- for col in source_cols -%}
            {%- if col | lower not in exclude_columns | map('lower') | list -%}
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
expected format, either: {'source_relation': Relation, 'columns': {column_name: column_value}}
or: {'source_relation': Relation, 'columns': {column_name: {'source_column': column_value, 'escape': true / false}}}
got: {'source_relation': " ~ source_relation ~ ", 'columns': " ~ columns ~ "}") }}
{%- endif %}

{%- endif %}

{%- endmacro -%}
