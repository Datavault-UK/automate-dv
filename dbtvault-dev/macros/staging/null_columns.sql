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
        {%- filter indent(width=0) -%}
        {%- for col_name in ns.required -%}
            {{ dbtvault.null_column_sql(col_name, required_value) }}{{ ",\n" if not loop.last }}{{ ",\n" if loop.last and dbtvault.is_something(ns.optional) else "" }}
        {%- endfor -%}
        {%- endfilter -%}
    {%- endif -%}

    {%- if dbtvault.is_something(ns.optional) -%}
        {%- filter indent(width=0) -%}
        {%- for col_name in ns.optional -%}
            {{ dbtvault.null_column_sql(col_name, optional_value) }}{{ ",\n" if not loop.last else "\n" }}
        {%- endfor -%}
        {%- endfilter -%}
    {%- endif -%}

{%- endif -%}

{%- endmacro -%}


{%- macro null_column_sql(col_name, default_value) -%}

    {{- adapter.dispatch('null_column_sql', 'dbtvault')(col_name=col_name, default_value=default_value) -}}

{%- endmacro -%}

{%- macro default__null_column_sql(col_name, default_value) -%}

    {%- set col_name_esc = dbtvault.escape_column_names(col_name) -%}
    {%- set col_name_orig_esc = dbtvault.escape_column_names(col_name ~ "_ORIGINAL") -%}
    {{ col_name_esc }} AS {{ col_name_orig_esc }},
    IFNULL({{ col_name_esc }}, '{{ default_value }}') AS {{ col_name_esc }}

{%- endmacro -%}

{%- macro sqlserver__null_column_sql(col_name, default_value) -%}

    {%- set col_name_esc = dbtvault.escape_column_names(col_name) -%}
    {%- set col_name_orig_esc = dbtvault.escape_column_names(col_name ~ "_ORIGINAL") -%}
    {{ col_name_esc }} AS {{ col_name_orig_esc }},
    ISNULL({{ col_name_esc }}, '{{ default_value }}') AS {{ col_name_esc }}

{%- endmacro -%}

{%- macro postgres__null_column_sql(col_name, default_value) -%}

    {%- set col_name_esc = dbtvault.escape_column_names(col_name) -%}
    {%- set col_name_orig_esc = dbtvault.escape_column_names(col_name ~ "_ORIGINAL") -%}
    {{ col_name_esc }} AS {{ col_name_orig_esc }},
    COALESCE({{ col_name_esc }}, '{{ default_value }}') AS {{ col_name_esc }}

{%- endmacro -%}