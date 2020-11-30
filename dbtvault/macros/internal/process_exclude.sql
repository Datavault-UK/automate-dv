{%- macro process_exclude(source_relation=none, derived_columns=none ,columns=none) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}
{% if exclude_flag is none %}
    {%- set exclude_flag = false -%}
{% endif %}

{#- getting all the source collumns and derived columns -#}

{%- set source_columns = dbtvault.source_columns(source_relation=source_relation) -%}


{%- if columns is mapping -%}

    {%- for col in columns -%}


        {% if columns[col] is mapping and columns[col].exclude_flag -%}



            {%- for flagged_cols in columns[col]['columns'] -%}

                {%- set _ = exclude_columns.append(flagged_cols) -%}

            {%- endfor -%}

            {%- if derived_columns is not none -%}
                {%- for derived_col in derived_columns -%}
                    {%- if derived_col not in exclude_columns -%}
                        {% set column_str = dbtvault.as_constant(derived_columns[derived_col]) %}
                        {%- set _ = include_columns.append(column_str ~ " AS " ~ derived_col) -%}
                        {%- set _ = exclude_columns.append(derived_col)  -%}
                     {%- endif -%}
                {%- endfor -%}


            {%- endif -%}


            {%- for source_col in source_columns -%}
                {%- if source_col not in exclude_columns -%}
                     {%- set _ = include_columns.append(source_col) -%}
                 {%- endif -%}
            {%- endfor -%}


            {%- do columns[col].update({'columns': include_columns}) -%}
            {%- set include_columns = [] -%}
            {%- set exclude_columns = [] -%}


        {%- endif -%}
    {%- endfor -%}
{%- endif -%}


{%- do return(columns) -%}


{%- endmacro -%}



{%- macro process_source_and_derived(primary_set_list=none, secondary_set_list=none ,exclude_columns=none) -%}

{%- set include_columns = [] -%}

{%- if exclude_columns is none -%}
    {%- set exclude_columns = [] -%}
{%- endif -%}


{%- if primary_set_list is not none -%}
    {%- for primary_col in primary_set_list -%}
        {%- if primary_col not in exclude_columns -%}
            {% set column_str = dbtvault.as_constant(derived_columns[derived_col]) %}
            {%- set _ = include_columns.append(column_str ~ " AS " ~ derived_col) -%}
            {%- set _ = exclude_columns.append(derived_col)  -%}
        {%- endif -%}
    {%- endfor -%}
{%- endif -%}


{%- for source_col in source_columns -%}
    {%- if source_col not in exclude_columns -%}
        {%- set _ = include_columns.append(source_col) -%}
    {%- endif -%}
{%- endfor -%}

{%- do return(columns) -%}

{%- endmacro -%}