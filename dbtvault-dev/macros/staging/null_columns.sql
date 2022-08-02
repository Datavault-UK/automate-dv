{%- macro null_columns(source_relation=none, columns=none) -%}

    {{- adapter.dispatch('null_columns', 'dbtvault')(source_relation=source_relation, columns=columns) -}}

{%- endmacro %}

{%- macro default__null_columns(source_relation=none, columns=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- set ns = namespace() -%}

    {%- for col in columns -%}
        {%- if col.lower() == 'required' -%}
            {%- set ns.required = columns[col] -%}
        {%- endif -%}
        {%- if col.lower() == 'optional' -%}
            {%- set ns.optional = columns[col] -%}
        {%- endif -%}
    {%- endfor -%}

    {%- set required_value = var('null_key_required', '-1') -%}
    {%- set optional_value = var('null_key_required', '-2') -%}

    {% if dbtvault.is_something(ns.required) %}
        {{ dbtvault.escape_column_names(ns.required) }} AS {{ dbtvault.escape_column_names(ns.required ~ "_ORIGINAL") }},
        IFNULL({{ dbtvault.escape_column_names(ns.required) }}, '{{ required_value }}') AS {{ dbtvault.escape_column_names(ns.required) }}{{ "," if dbtvault.is_something(ns.optional) else "" }}
    {% endif %}

    {% if dbtvault.is_something(ns.optional) %}
        {{ dbtvault.escape_column_names(ns.optional) }} AS {{ dbtvault.escape_column_names(ns.optional ~ "_ORIGINAL") }},
        IFNULL({{ dbtvault.escape_column_names(ns.optional) }}, '{{ optional_value }}') AS {{ dbtvault.escape_column_names(ns.optional) }}
    {% endif %}

{%- endif -%}

{%- endmacro -%}