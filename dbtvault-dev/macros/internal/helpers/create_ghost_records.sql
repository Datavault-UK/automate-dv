{%- macro create_ghost_records(source_model, source_columns) -%}

    {{- adapter.dispatch('create_ghost_records', 'dbtvault')(source_model=source_model, source_columns=source_columns) -}}

{%- endmacro %}

{%- macro default__create_ghost_records(source_model, source_columns) -%}

  {%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
  {%- set col_defintions = [] -%}

  {%- for col in columns -%}
    {%- do log("columns: " ~ col, true) %}
    {%- set string_col = '"{}"'.format(col.column) -%}
        {%- if string_col in source_columns -%}

            {%- set fetched_type = col.dtype -%}
            {%- set fetched_name = col.column -%}
            {%- set fetched_string = dbtvault.ghost_string_lookup()[fetched_type] -%}
            {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, col.column) -%}

            {%- col_defintions.append(col_sql) %-}



  {%- endif -%}

{%- endfor -%}

SELECT {% for col in col_definitions %} {{ col }} {% if not loop.last %},{% endif %}{% endfor %}

{% endmacro %}