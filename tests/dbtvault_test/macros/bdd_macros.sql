{%- macro drop_model(model_name) -%}

    {%- set source_relation = adapter.get_relation(
          database=target.database,
          schema=target.schema,
          identifier=model_name) -%}

    {% if source_relation %}
        {%- do adapter.drop_relation(source_relation) -%}
        {% do log('Successfully dropped model ' ~ "'" ~ model_name ~ "'", true) %}
    {% else %}
        {% do log('Nothing to drop', true) %}
    {% endif %}

{%- endmacro -%}

{%- macro drop_current_schema() -%}

{%- do adapter.drop_schema(target.database, target.schema) %}

{% endmacro %}

{%- macro create_current_schema() -%}

{%- do adapter.create_schema(target.database, target.schema) %}

{%- endmacro -%}

{%- macro recreate_current_schema() -%}

{{ drop_current_schema() }}
{{ create_current_schema() }}

{%- endmacro -%}