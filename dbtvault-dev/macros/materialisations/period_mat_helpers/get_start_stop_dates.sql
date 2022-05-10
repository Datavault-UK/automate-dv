{% macro get_start_stop_dates(timestamp_field, date_source_models) %}

    {% if config.get('start_date', default=none) is not none %}

        {%- set start_date = config.get('start_date') -%}
        {%- set stop_date = config.get('stop_date', default=none) -%}

        {% do return({'start_date': start_date,'stop_date': stop_date}) %}

    {% elif date_source_models is not none %}

        {% if date_source_models is string %}
            {% set date_source_models = [date_source_models] %}
        {% endif %}
        {% set query_sql %}
            WITH stage AS (
            {% for source_model in date_source_models %}
                SELECT {{ timestamp_field }} FROM {{ ref(source_model) }}
                {% if not loop.last %} UNION ALL {% endif %}
            {% endfor %})

            SELECT MIN({{ timestamp_field }}) AS MIN, MAX({{ timestamp_field }}) AS MAX
            FROM stage
        {% endset %}

        {% set min_max_dict = dbtvault.get_query_results_as_dict(query_sql) %}

        {% set start_date = min_max_dict['MIN'][0] | string %}
        {% set stop_date = min_max_dict['MAX'][0] | string %}
        {% set min_max_dates = {"start_date": start_date, "stop_date": stop_date} %}

        {% do return(min_max_dates) %}

    {% else %}
        {%- if execute -%}
            {{ exceptions.raise_compiler_error("Invalid 'vault_insert_by_period' configuration. Must provide 'start_date' and 'stop_date', just 'stop_date', and/or 'date_source_models' options.") }}
        {%- endif -%}
    {% endif %}

{% endmacro %}