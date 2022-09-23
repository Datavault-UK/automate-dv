{%- macro ghost_pk_cte(source_model, source_columns) -%}

  {{ columns=adapter.get_columns_in_relation(ref(source_model)) }}

  {%- set col_defintions = [] -%}

  {%- for col in columns -%}

  {%- if col in source_columns -%}

    {%- set fetched_type = col.dtype() -%}
    {%- set fetched_name = col.name() -%}
    {%- set fetched_string = ref(ghost_string_lookup)[fetched_type] -%}

    {%- col_sql = "CAST({} AS {}) AS {}".format(fetched_string, fetched_type, col) -%}

    {{ col_definitons.append(col_sql) }}
    {%- endif -%}

  {%- endfor -%}

SELECT {% for col in col_definitions %} {{ col }} {% if not loop.last %},{% endif %}{% endfor %}