{% macro config_meta_get(key, default=none) %}
    {%- if config.get(key) != none -%}
        {{ return(config.get(key)) }}
    {%- elif config.get("meta") != none and (key in config.get("meta", {}).keys()) -%}
        {{ return(config.get("meta").get(key)) }}
    {%- else -%}
        {{ return(default) }}
    {%- endif -%}
{% endmacro %}


{% macro config_meta_require(key) %}
    {# the first case is required to avoid errors #}
    {%- if config == {} -%}
        {{ return(none) }}
    {%- elif config.get(key) != none -%}
        {{ return(config.get(key)) }}
    {%- elif config.get("meta") != none and (key in config.get("meta", {}).keys()) -%}
        {{ return(config.get("meta").get(key)) }}
    {%- else -%}
        {% do exceptions.raise_compiler_error("Configuration '" ~ key ~ "' is required but was not found under config or meta (Fusion requires custom configuration under meta)") %}
    {%- endif -%}
{% endmacro %}