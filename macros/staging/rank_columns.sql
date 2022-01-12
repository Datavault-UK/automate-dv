{%- macro rank_columns(columns=none) -%}

    {{- adapter.dispatch('rank_columns', 'dbtvault')(columns=columns) -}}

{%- endmacro %}

{%- macro default__rank_columns(columns=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- for col in columns -%}

        {%- if columns[col] is mapping and columns[col].partition_by and columns[col].order_by -%}

            {%- set order_by = columns[col].order_by -%}
            {%- set partition_by = columns[col].partition_by -%}
            {%- set dense_rank = columns[col].dense_rank -%}

            {%- if dbtvault.is_nothing(dense_rank) %}
                {%- set rank_type = "RANK()" -%}
            {%- elif dense_rank is true -%}
                {%- set rank_type = "DENSE_RANK()" -%}
            {%- else -%}
                {%- if execute -%}
                    {%- do exceptions.raise_compiler_error('If dense_rank is provided, it must be true or false, not {}'.format(dense_rank)) -%}
                {% endif %}
            {%- endif -%}

            {%- if dbtvault.is_list(order_by) -%}

                {%- set order_by_str_lst = [] -%}

                {% for order_by_col in order_by %}

                    {%- if order_by_col is mapping %}
                        {%- set column_name, direction = order_by_col.items()|first -%}
                        {%- set order_by_str = "{} {}".format(dbtvault.escape_column_names(column_name), direction) | trim -%}
                    {%- else -%}
                        {%- set order_by_str = dbtvault.escape_column_names(order_by_col) -%}
                    {%- endif -%}

                    {%- do order_by_str_lst.append(order_by_str) -%}
                {%- endfor -%}

                {%- set order_by_str = order_by_str_lst | join(", ") -%}

            {%- else -%}

                {%- if order_by is mapping %}
                    {%- set column_name, direction = order_by.items()|first -%}
                {%- else -%}
                    {%- set column_name = order_by -%}
                    {%- set direction = '' -%}
                {%- endif -%}

                {%- set order_by_str = "{} {}".format(dbtvault.escape_column_names(column_name), direction) | trim -%}
            {%- endif -%}

            {%- if dbtvault.is_list(partition_by) -%}
                {%- set partition_by_str = dbtvault.escape_column_names(partition_by) | join(", ") -%}
            {%- else -%}
                {%- set partition_by_str = dbtvault.escape_column_names(partition_by) -%}
            {%- endif -%}

            {{- "{} OVER (PARTITION BY {} ORDER BY {}) AS {}".format(rank_type, partition_by_str, order_by_str, dbtvault.escape_column_names(col)) | indent(4) -}}

        {%- endif -%}

        {{- ",\n" if not loop.last -}}
    {%- endfor -%}

{%- endif %}
{%- endmacro -%}
