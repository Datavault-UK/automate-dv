{%- macro process_exclude(source_relation=source_releation, derived_columns=none ,columns=none) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}
{% if exclude_flag is none %}
    {%- set exclude_flag = false -%}
{% endif %}

{#- getting all the source collumns and derived columns -#}

{% set source_columns =(dbtvault.source_columns(source_relation=source_relation)) %}


{%- if columns is mapping -%}

    {%- for col in columns -%}

        {% if columns[col] is mapping and columns[col].exclude_flag -%}

            {%- set exclude_columns = columns[col]['columns'] -%}

            {%- if derived_columns is not none -%}
                {%- for col in derived_columns_columns -%}
                    {%- if col not in exclude_columns -%}
                         {%- set _ = include_columns.append(col) -%}
                     {%- endif -%}
                {%- endfor -%}

                {%- set _ = exclude_columns.apend(derived_columns)  -%}

            {%- endif -%}


            {%- for col in source_columns -%}
                {%- if col not in exclude_columns -%}
                     {%- set _ = include_columns.append(col) -%}
                 {%- endif -%}
            {%- endfor -%}
            {{ log('before'~included_columns, true) }}

            {%- do columns[col].update({'columns': include_columns}) -%}
              {{ log('after',included_columns) }}
            {%- set include_columns = [] -%}
            {%- set exclude_columns = [] -%}

        {%- endif -%}
    {%- endfor -%}
{%- endif -%}


{%- do return(columns) -%}


{%- endmacro -%}