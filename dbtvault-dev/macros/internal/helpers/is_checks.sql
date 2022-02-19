{%- macro is_list(obj, empty_is_false=false) -%}

    {%- if obj is iterable and obj is not string and obj is not mapping -%}
        {%- if obj is none and obj is undefined and not obj and empty_is_false -%}
            {%- do return(false) -%}
        {%- endif -%}

        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}



{%- macro is_nothing(obj) -%}

    {%- if obj is none or obj is undefined or not obj -%}
        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}



{%- macro is_something(obj) -%}

    {%- if obj is not none and obj is defined and obj -%}
        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}



{%- macro is_expression(obj) -%}

    {%- if obj is string -%}
        {%- if (obj | first == "'" and obj | last == "'") or ("(" in obj and ")" in obj) or "::" in obj -%}
            {%- do return(true) -%}
        {%- else -%}
            {%- do return(false) -%}
        {%- endif -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}



{% macro is_vault_insert_by_period() %}
    {% if not execute %}
        {{ return(False) }}
    {% else %}
        {% set relation = adapter.get_relation(this.database, this.schema, this.table) %}

            {{ return(relation is not none
                      and relation.type == 'table'
                      and model.config.materialized == 'vault_insert_by_period'
                      and not flags.FULL_REFRESH) }}
    {% endif %}
{% endmacro %}
