{% macro log_warning(message) %}

    {%- if automate_dv.is_something(invocation_args_dict.get('which')) and invocation_args_dict.get('which') != 'compile' -%}
        {%- do exceptions.warn(message) -%}
    {%- endif -%}

{% endmacro %}