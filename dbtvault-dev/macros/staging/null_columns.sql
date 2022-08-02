{%- macro null_columns(source_relation=none, columns=none) -%}

    {{- adapter.dispatch('null_columns', 'dbtvault')(source_relation=source_relation, columns=columns) -}}

{%- endmacro %}

{%- macro default__null_columns(source_relation=none, columns=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- set ns = namespace() -%}

    {%- for col in columns -%}
        {%- if col.lower() == 'required' -%}
            {% if dbtvault.is_something(columns[col]) %}
                {%- if columns[col] is string -%}
                    {%- set ns.required = [columns[col]] -%}
                {%- elif dbtvault.is_list(columns[col]) -%}
                    {%- set ns.required = columns[col] -%}
                {%- endif -%}
            {%- endif -%}
        {%- endif -%}
        {%- if col.lower() == 'optional' -%}
            {% if dbtvault.is_something(columns[col]) %}
                {%- if columns[col] is string -%}
                    {%- set ns.optional = [columns[col]] -%}
                {%- elif dbtvault.is_list(columns[col]) -%}
                    {%- set ns.optional = columns[col] -%}
                {%- endif -%}
            {%- endif -%}
        {%- endif -%}
    {%- endfor -%}

    {%- set required_value = var('null_key_required', '-1') -%}
    {%- set optional_value = var('null_key_optional', '-2') -%}

    {%- if dbtvault.is_something(ns.required) -%}
        {%- filter indent(width=0, first=true) -%}
        {%- for col_name in ns.required -%}
            {{ dbtvault.escape_column_names(col_name) }} AS {{ dbtvault.escape_column_names(col_name ~ "_ORIGINAL") }},
            IFNULL({{ dbtvault.escape_column_names(col_name) }}, '{{ required_value }}') AS {{ dbtvault.escape_column_names(col_name) }}{{ ",\n" if not loop.last }}{{ ",\n" if loop.last and dbtvault.is_something(ns.optional) else "" }}
        {%- endfor -%}
        {%- endfilter -%}
    {%- endif -%}

    {%- if dbtvault.is_something(ns.optional) -%}
        {%- filter indent(width=0, first=true) -%}
        {%- for col_name in ns.optional -%}
            {{ dbtvault.escape_column_names(col_name) }} AS {{ dbtvault.escape_column_names(col_name ~ "_ORIGINAL") }},
            IFNULL({{ dbtvault.escape_column_names(col_name) }}, '{{ optional_value }}') AS {{ dbtvault.escape_column_names(col_name) }}{{ ",\n" if not loop.last else "\n" }}
        {%- endfor -%}
        {%- endfilter -%}
    {%- endif -%}

{%- endif -%}

{%- endmacro -%}