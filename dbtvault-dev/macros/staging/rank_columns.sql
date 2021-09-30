{%- macro rank_columns(columns=none) -%}

    {{- adapter.dispatch('rank_columns', 'dbtvault')(columns=columns) -}}

{%- endmacro %}

{%- macro default__rank_columns(columns=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- for col in columns -%}

        {%- if columns[col] is mapping and columns[col].partition_by and columns[col].order_by -%}

            {%- if dbtvault.is_nothing(columns[col].dense_rank) %}
                {%- set rank_type = "RANK()" -%}
            {%- elif columns[col].dense_rank is true -%}
                {%- set rank_type = "DENSE_RANK()" -%}
            {%- else -%}
                {%- if execute -%}
                    {%- do exceptions.raise_compiler_error('If dense_rank is provided, it must be true or false, not {}'.format(columns[col].dense_rank)) -%}
                {% endif %}
            {%- endif -%}

            {%- if dbtvault.is_list(columns[col].order_by) -%}

                {%- if columns[col].order_by is mapping %}
                    {%- do log('order by: {}'.format(columns[col].order_by, true)) -%}
{#                    {%- set column_name, direction = columns[col].order_by.items()[0] -%}#}
{#                {%- else -%}#}
{#                    {%- set column_name = columns[col].order_by -%}#}
{#                    {%- set direction = '' -%}#}
                {%- endif -%}

                {%- set order_by_str = "{} {}".format(column_name, direction) | join(", ") -%}
            {%- else -%}

                {%- if columns[col].order_by is mapping %}
                    {%- do log('order by: {}'.format(columns[col].order_by, true)) -%}
{#                    {%- set column_name, direction = columns[col].order_by.items()[0] -%}#}
{#                {%- else -%}#}
{#                    {%- set column_name = columns[col].order_by -%}#}
{#                    {%- set direction = '' -%}#}
                {%- endif -%}

                {%- set order_by_str = "{} {}".format(column_name, direction) -%}
            {%- endif -%}

            {%- if dbtvault.is_list(columns[col].partition_by) -%}
                {%- set partition_by_str = columns[col].partition_by | join(", ") -%}
            {%- else -%}
                {%- set partition_by_str = columns[col].partition_by -%}
            {%- endif -%}

            {{- "{} OVER (PARTITION BY {} ORDER BY {}) AS {}".format(rank_type, partition_by_str, order_by_str, col) | indent(4) -}}

        {%- endif -%}

        {{- ",\n" if not loop.last -}}
    {%- endfor -%}

{%- endif %}
{%- endmacro -%}
