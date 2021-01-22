{%- macro rank_columns(columns=none) -%}

    {{- adapter.dispatch('rank_columns', packages = dbtvault.get_dbtvault_namespaces())(columns=columns) -}}

{%- endmacro %}

{%- macro default__rank_columns(columns=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- for col in columns -%}

        {%- if columns[col] is mapping and columns[col].partition_by and columns[col].order_by -%}

            {{- "RANK() OVER (PARTITION BY {} ORDER BY {}) AS {}".format(columns[col].partition_by, columns[col].order_by, col) | indent(4) -}}

        {%- endif -%}

        {{- ",\n" if not loop.last -}}
    {%- endfor -%}

{%- endif %}
{%- endmacro -%}
