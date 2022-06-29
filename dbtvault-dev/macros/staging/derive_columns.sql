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
    {%- do log('@@@ columns ' ~ columns, true) -%}

    {#- Add aliases of derived columns to excludes and full SQL to includes -#}
    {%- for col in columns -%}
        {%- do log('@@@ column alias ' ~ col, true) -%}
        {% set col_alias = col %}
        {%- do log('@@@ column config ' ~ columns[col], true) -%}
        {% set col_config = columns[col] %}

        {%- if dbtvault.is_list(col_config) -%}
            {%- set column_list = [] -%}

            {%- for concat_component in columns[col_alias] -%}
                {%- if concat_component is mapping and concat_component is not none -%}
                    {%- set column_str = dbtvault.as_constant(concat_component['source_column']) -%}
                    {%- set column_escape = concat_component['escape'] -%}
                    {%- if column_escape is true -%}
                        {%- set column_str = dbtvault.escape_column_names(dbtvault.as_constant(column_str)) -%}
                    {% else %}
                        {%- set column_str = dbtvault.as_constant(column_str) -%}
                    {% endif %}
                {%- else -%}
                    {%- set column_str = dbtvault.as_constant(concat_component) -%}
                    {%- if column_str | first == '?' %}
                        {%- set column_str = dbtvault.escape_column_names(column_str[1:]) -%}
                    {% endif %}
                {%- endif -%}
                {%- do column_list.append(column_str) -%}
            {%- endfor -%}
            {%- set concat = dbtvault.concat_ws(column_list, "||") -%}
            {%- set concat_string = concat ~ " AS " ~ dbtvault.escape_column_names(col_alias) -%}

            {%- do der_columns.append(concat_string) -%}
            {%- do exclude_columns.append(col_alias) -%}
            {%- do log('@@@ der_columns ' ~ der_columns, true) -%}
            {%- do log('@@@ exclude_columns ' ~ exclude_columns, true) -%}
        {%- else -%}
            {%- if col_config is mapping and col_config is not none -%}
                {%- set column_str = dbtvault.as_constant(col_config['source_column']) -%}
                {%- set column_escape = col_config['escape'] -%}
                {%- do log('@@@ column_escape ' ~ column_escape, true) -%}
                {%- if column_escape is true -%}
                    {%- do der_columns.append(dbtvault.escape_column_names(column_str) ~ " AS " ~ dbtvault.escape_column_names(col_alias)) -%}
                {%- else -%}
                    {%- do der_columns.append(column_str ~ " AS " ~ dbtvault.escape_column_names(col_alias)) -%}
                {%- endif -%}
            {%- else -%}
                {%- set column_str = dbtvault.as_constant(col_config) -%}
                {%- if column_str | first == '?' %}
                    {%- set column_str = dbtvault.escape_column_names(column_str[1:]) -%}
                {% endif %}
                {%- do der_columns.append(column_str ~ " AS " ~ dbtvault.escape_column_names(col_alias)) -%}
            {%- endif -%}
            {%- do exclude_columns.append(col_alias) -%}
        {%- endif -%}

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
    {%- do log('@@@ source_cols ' ~ source_cols, true) -%}
    {%- do log('@@@ exclude_columns ' ~ exclude_columns, true) -%}
    {%- do log('@@@ src_columns ' ~ src_columns, true) -%}
    {%- do log('@@@ der_columns ' ~ der_columns, true) -%}
    {%- do log('@@@ include_columns ' ~ include_columns, true) -%}

{%- else -%}

{%- if execute -%}
{{ exceptions.raise_compiler_error("Invalid column configuration:
expected format: {'source_relation': Relation, 'columns': {column_name: column_value}}
got: {'source_relation': " ~ source_relation ~ ", 'columns': " ~ columns ~ "}") }}
{%- endif %}

{%- endif %}

{%- endmacro -%}