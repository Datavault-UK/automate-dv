{% macro config_meta_get(key, default=none) %}
    {# 1. Try to get from meta #}
    {%- set meta_val = config.meta_get(key) -%}
    {%- if meta_val != none -%}
        {{ return(meta_val) }}
    {%- endif -%}

    {# 2. If not found in meta, try the standard config #}
    {# This line is now safe because we know the key is NOT in meta #}
    {%- set config_val = config.get(key) -%}
    {%- if config_val != none -%}
        {{ return(config_val) }}
    {%- endif -%}

    {# 3. Return default if found in neither #}
    {{ return(default) }}
{% endmacro %}


{% macro config_meta_require(key) %}
    {# 1. Try to get from meta #}
    {%- set meta_val = config.meta_require(key) -%}
    {%- if meta_val != none -%}
        {{ return(meta_val) }}
    {%- endif -%}

    {# 2. If not found in meta, try the standard config #}
    {%- set config_val = config.require(key) -%}
    {%- if config_val != none -%}
        {{ return(config_val) }}
    {%- endif -%}

    {# 3. Raise error if found in neither #}
    {% do exceptions.raise_compiler_error("Configuration '" ~ key ~ "' is required but was not found under config or meta (Fusion requires custom configuration under meta)") %}
{% endmacro %}