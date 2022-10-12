{%- macro create_ghost_records(source_model, source_columns) -%}

    {{- adapter.dispatch('create_ghost_records', 'dbtvault')(source_model=source_model, source_columns=source_columns) -}}

{%- endmacro %}

{%- macro default__create_ghost_records(source_model, source_columns) -%}

{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set needed_column = [] -%}

{%- for col in columns -%}
    {%- do log("columns: " ~ col, true) %}
    {%- set string_col = '"{}"'.format(col.column) -%}
    {%- if string_col in source_columns -%}

        {%- set fetched_type = col.dtype -%}
        {%- do log("type: " ~ fetched_type, true) %}
        {%- set fetched_name = col.column -%}
        {%- do log("name: " ~ fetched_name, true) %}
        {%- set fetched_string = dbtvault.ghost_string_lookup()[fetched_type] -%}
        {%- do log("string: " ~ fetched_string, true) %}
        {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, col.column) -%}
        {%- do log("col_sql: " ~ col_sql, true) %}
        {%- needed_column.append(col_sql) %-}

    {%- endif -%}

{%- endfor -%}

{% do log("Matched columns" ~ needed_column, true) %}

SELECT {% for col in needed_column %} {{ col }} {% if not loop.last %},{% endif %}{% endfor %}

{% endmacro %}