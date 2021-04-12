{%- macro rank_columns(columns=none) -%}

    {{- adapter.dispatch('rank_columns', packages = dbtvault.get_dbtvault_namespaces())(columns=columns) -}}

{%- endmacro %}

{%- macro default__rank_columns(columns=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- for col in columns -%}

        {%- if columns[col] is mapping and columns[col].partition_by and columns[col].order_by -%}

            {%- if dbtvault.is_list(columns[col].order_by) -%}
                {%- set order_by_str = columns[col].order_by | join(", ") -%}
            {%- else -%}
                {%- set order_by_str = columns[col].order_by -%}
            {%- endif -%}

            {{- "RANK() OVER (PARTITION BY {} ORDER BY {}) AS {}".format(columns[col].partition_by, order_by_str, col) | indent(4) -}}

        {%- endif -%}

        {{- ",\n" if not loop.last -}}
    {%- endfor -%}

{%- endif %}
{%- endmacro -%}
