{% macro config_meta_get(key, default=none) %}
    {%- if automate_dv.config_meta_get(key) != none -%}
        {{ return(automate_dv.config_meta_get(key)) }}
    {%- else-%}
        {{ return(automate_dv.config_meta_get("meta").get(key, default)) }}
    {%- endif -%}
{% endmacro %}


{% macro config_meta_require(key) %}
    {# the first case is required to avoid errors #}
    {%- if config == {} -%}
        {{ return(none) }}
    {%- elif automate_dv.config_meta_get(key) != none -%}
        {{ return(automate_dv.config_meta_get(key)) }}
    {%- elif key in automate_dv.config_meta_get("meta", {}).keys() -%}
        {{ return(automate_dv.config_meta_get("meta").get(key)) }}
    {%- else -%}
        {% do exceptions.raise_compiler_error("Configuration '" ~ key ~ "' is required but was not found under config or meta (Fusion requires custom configuration under meta)") %}
    {%- endif -%}
{% endmacro %}