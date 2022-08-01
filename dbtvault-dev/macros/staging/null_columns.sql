{%- macro null_columns(source_relation=none, columns=none) -%}

    {%- set required = columns['REQUIRED'] | indent(4) -%}
    {%- set optional = columns['OPTIONAL'] | indent(4) -%}

    {%- if dbtvault.is_something(required) %}
    {{ required }} AS {{ required }}_ORIGINAL,
    IFNULL({{ required }}, '-1') AS {{ required }}_NEW{{ "," if dbtvault.is_something(optional) else "" }}
    {%- endif -%}

    {%- if dbtvault.is_something(optional) %}
    {{ optional }} AS {{ optional }}_ORIGINAL,
    IFNULL({{ optional }}, '-1') AS {{ optional }}_NEW
    {%- endif -%}

{%- endmacro -%}