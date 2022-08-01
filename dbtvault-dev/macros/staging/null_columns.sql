{%- macro null_columns(source_relation=none, columns=none) -%}

    {%- set required = columns['REQUIRED'] | indent(4) -%}
    {%- set optional = columns['OPTIONAL'] | indent(4) -%}
    {%- set required_value = var('null_key_required', -1) -%}
    {%- set optional_value = var('null_key_required', -2) -%}

    {%- if dbtvault.is_something(required) %}
    {{ required }} AS {{ required }}_ORIGINAL,
    IFNULL({{ required }}, {{ required_value }}) AS {{ required }}_NEW{{ "," if dbtvault.is_something(optional) else "" }}
    {%- endif -%}

    {%- if dbtvault.is_something(optional) %}
    {{ optional }} AS {{ optional }}_ORIGINAL,
    IFNULL({{ optional }}, {{ optional_value }}) AS {{ optional }}_NEW
    {%- endif -%}

{%- endmacro -%}