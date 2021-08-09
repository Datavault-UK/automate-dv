{%- macro rank_columns(columns=none) -%}

    {{- adapter.dispatch('rank_columns', 'dbtvault')(columns=columns) -}}

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

            {%- if dbtvault.is_list(columns[col].partition_by) -%}
                {%- set partition_by_str = columns[col].partition_by | join(", ") -%}
            {%- else -%}
                {%- set partition_by_str = columns[col].partition_by -%}
            {%- endif -%}

            {{- "RANK() OVER (PARTITION BY {} ORDER BY {}) AS {}".format(partition_by_str, order_by_str, col) | indent(4) -}}

        {%- endif -%}

        {{- ",\n" if not loop.last -}}
    {%- endfor -%}

{%- endif %}
{%- endmacro -%}
