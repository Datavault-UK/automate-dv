{% macro _config_meta_lookup(key) %}
    {%- set meta = config.get('meta') or {} -%}

    {%- if key in meta -%}
        {{ return(meta[key]) }}
    {%- endif -%}

    {%- set config_val = config.get(key) -%}

    {%- if config_val is not none -%}
        {{ return(config_val) }}
    {%- endif -%}

    {{ return(none) }}
{% endmacro %}


{% macro config_meta_get(key, default=none) %}
    {%- set value = automate_dv._config_meta_lookup(key) -%}

    {%- if value is not none -%}
        {{ return(value) }}
    {%- endif -%}

    {{ return(default) }}
{% endmacro %}


{% macro config_meta_require(key) %}
    {%- set value = automate_dv._config_meta_lookup(key) -%}

    {%- if value is not none -%}
        {{ return(value) }}
    {%- endif -%}

    {% do exceptions.raise_compiler_error(
        "Configuration '" ~ key ~ "' is required but was not found under config or meta"
    ) %}
{% endmacro %}