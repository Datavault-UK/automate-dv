{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = var('database', target.database)  -%}

    {% if target.type == 'databricks' and target.catalog and not default_database %}
        {%- set default_database = target.catalog -%}
    {% endif %}

    {%- if custom_database_name is none -%}

        {{ default_database }}

    {%- else -%}

        {{ custom_database_name | trim }}

    {%- endif -%}

{%- endmacro %}
