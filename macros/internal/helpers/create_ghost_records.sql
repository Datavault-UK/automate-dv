{%- macro create_ghost_records(source_model, source_columns) -%}

    {{- adapter.dispatch('create_ghost_records', 'dbtvault')(source_model=source_model, source_columns=source_columns) -}}

{%- endmacro %}

{%- macro default__create_ghost_records(source_model, source_columns) -%}

{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}
{%- set ghost_string = dbtvault.ghost_string_lookup() -%}


{%- for col in columns -%}
    {%- do log("columns: " ~ col, true) %}
    {%- set string_col = '"{}"'.format(col.column) -%}
    {%- if string_col in source_columns -%}

        {%- set fetched_type = col.dtype -%}
        {%- do log("type: " ~ fetched_type, true) %}
        {%- set fetched_name = col.column -%}
        {%- do log("name: " ~ fetched_name, true) -%}
        {%- set type_string = 'TYPE_{}'.format(fetched_type|string()) -%}
        {%- set fetched_string = ghost_string[type_string] -%}
        {%- do log("string: " ~ fetched_string, true) %}
        {%- if fetched_string == 'NULL' -%}
            {%- set col_sql = "NULL AS {}".format(fetched_name) -%}
        {%- elif fetched_type == 'TYPE_DATE' -%}
            {%- set col_sql = "TO_DATE({}) AS {}".format(fetched_string, fetched_name) -%}
        {%- else -%}
            {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, fetched_name) -%}
        {%- endif -%}
        {%- do log("col_sql: " ~ col_sql, true) %}
        {%- do col_definitions.append(col_sql) -%}

    {%- endif -%}

{%- endfor -%}

{% do log("Matched columns: " ~ needed_column, true) %}

SELECT {% for col in col_definitions %} {{ col }} {% if not loop.last %},{% endif %}{% endfor %}

{% endmacro %}