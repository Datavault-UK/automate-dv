{% macro config_meta_get(key, default=none) %}
    {# 1. Try to get from meta dictionary directly #}
    {%- set meta = config.get('meta') or {} -%}
    
    {# We check if the key exists inside the meta dictionary #}
    {%- if key in meta -%}
        {{ return(meta[key]) }}
    {%- endif -%}

    {# 2. If not found in meta, try the standard config #}
    {%- set config_val = config.get(key) -%}
    
    {%- if config_val is not none -%}
        {{ return(config_val) }}
    {%- endif -%}

    {# 3. Return default if found in neither #}
    {{ return(default) }}
{% endmacro %}


{% macro config_meta_require(key) %}
    {# 1. Try to get from meta dictionary directly #}
    {%- set meta = config.get('meta') or {} -%}
    
    {# We check if the key exists inside the meta dictionary #}
    {%- if key in meta -%}
        {{ return(meta[key]) }}
    {%- endif -%}

    {# 2. If not found in meta, try the standard config #}
    {%- set config_val = config.get(key) -%}
    
    {%- if config_val is not none -%}
        {{ return(config_val) }}
    {%- endif -%}

    {# 3. Raise error if found in neither #}
    {% do exceptions.raise_compiler_error("Configuration '" ~ key ~ "' is required but was not found under config or meta") %}
{% endmacro %}