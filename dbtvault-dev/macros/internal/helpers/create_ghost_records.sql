{%- macro create_ghost_records(source_model, source_columns) -%}

    {{- adapter.dispatch('create_ghost_records', 'dbtvault')(source_model=source_model, source_columns=source_columns) -}}

{%- endmacro %}

{%- macro default__create_ghost_records(source_model, source_columns) -%}

  {%- set columns = adapter.get_columns_in_relation(source_model) -%}
{% do log("columns1: " ~ col, true) %}
  {%- set col_defintions = [] -%}

  {%- for col in columns -%}
  {% do log("columns: " ~ col, true) %}
  {%- if col in source_columns -%}

    {%- set fetched_type = col.dtype() -%}
    {%- set fetched_name = col.name() -%}
    {%- set fetched_string = ref(ghost_string_lookup)[fetched_type] -%}

    {%- set col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, col) -%}
    {% do log("col_sql " ~ col_sql, true) %}
    {{ col_definitons.append(col_sql) }}
    {%- endif -%}

  {%- endfor -%}

{% do log("col_definitions: " ~ col_definitions, true) %}

SELECT {% for col in col_definitions %} {{ col }} {% if not loop.last %},{% endif %}{% endfor %}

{% endmacro %}