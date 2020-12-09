{%- macro process_excludes(source_relation=none, derived_columns=none, columns=none) -%}

{%- set exclude_columns_list = [] -%}
{%- set include_columns = [] -%}
{%- if exclude_columns is none -%}
    {%- set exclude_columns = false -%}
{% endif %}

{#- getting all the source columns -#}

{%- set source_columns = dbtvault.source_columns(source_relation=source_relation) -%}

{%- if columns is mapping -%}

    {%- for col in columns -%}

        {# Checks if the exclude flag is present and then creates a exclude list to pass to NEED BETTER NAME FOR MACRO #}
        {%- if columns[col] is mapping and columns[col].exclude_columns -%}

            {%- for flagged_cols in columns[col]['columns'] -%}

                {%- do exclude_columns_list.append(flagged_cols) -%}

            {%- endfor -%}

            {%- set include_columns = dbtvault.process_include_columns(primary_set_list=derived_columns, secondary_set_list=source_columns, exclude_columns_list=exclude_columns_list) -%}

            {#- Updates the the apropriate hashdiff to contain the columns we do want to hash  -#}
            {%- do columns[col].update({'columns': include_columns}) -%}
            {%- do columns[col].pop('exclude_columns') -%}
            {%- set include_columns = [] -%}
            {%- set exclude_columns = [] -%}

        {%- endif -%}
    {%- endfor -%}
{%- endif -%}

{%- do return(columns) -%}


{%- endmacro -%}


{%- macro process_include_columns(primary_set_list=none, secondary_set_list=none, exclude_columns_list=none) -%}

{%- set include_columns = [] -%}

{%- if exclude_columns is none -%}
    {%- set exclude_columns_list = [] -%}
{%- endif -%}

{# Appending primary list items not in exclude columns #}
{%- if primary_set_list is not none -%}

    {%- for primary_col in primary_set_list -%}

        {%- if primary_col not in exclude_columns_list -%}

            {%- if primary_set_list is mapping -%}
                {%- set primary_str = dbtvault.as_constant(primary_col) -%}
                {%- do include_columns.append(primary_str) -%}
                {%- do exclude_columns_list.append(primary_str)  -%}
            {%- else -%}
                {%- do include_columns.append(primary_col) -%}
                {%- do exclude_columns_list.append(primary_col) -%}
            {%- endif -%}

        {%- endif -%}

    {%- endfor -%}

{%- endif -%}

{# Apending the secondary list items not in the priamry list or the exclude list #}
{%- if secondary_set_list is not none -%}

    {%- for secondary_col in secondary_set_list -%}

        {%- if secondary_col not in exclude_columns_list -%}

            {%- if secondary_set_list is mapping -%}
                {%- set secondary_str = dbtvault.as_constant(secondary_col) -%}
                {%- do include_columns.append(secondary_str) -%}
            {%- else -%}
                {%- do include_columns.append(secondary_col) -%}
            {%- endif -%}

        {%- endif -%}

    {% endfor -%}

{%- endif -%}

{%- do return(include_columns) -%}

{%- endmacro -%}