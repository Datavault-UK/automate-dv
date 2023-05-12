/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro hash_columns(columns=none, columns_to_escape=none) -%}

    {{- adapter.dispatch('hash_columns', 'automate_dv')(columns=columns, columns_to_escape=columns_to_escape) -}}

{%- endmacro %}

{%- macro default__hash_columns(columns=none, columns_to_escape=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- for col in columns -%}

        {%- if columns[col] is mapping and columns[col].is_hashdiff -%}

            {{- automate_dv.hash(columns=columns[col]['columns'],
                              alias=col,
                              is_hashdiff=columns[col]['is_hashdiff'],
                              columns_to_escape=columns_to_escape) -}}

        {%- elif columns[col] is not mapping -%}

            {{- automate_dv.hash(columns=columns[col],
                              alias=col,
                              is_hashdiff=false,
                              columns_to_escape=columns_to_escape) -}}

        {%- elif columns[col] is mapping and not columns[col].is_hashdiff -%}

            {%- if execute -%}
                {%- do exceptions.warn("[" ~ this ~ "] Warning: You provided a list of columns under a 'columns' key, but did not provide the 'is_hashdiff' flag. Use list syntax for PKs.") -%}
            {% endif %}

            {{- automate_dv.hash(columns=columns[col]['columns'], alias=col, columns_to_escape=columns_to_escape) -}}

        {%- endif -%}

        {{- ",\n\n" if not loop.last -}}
    {%- endfor -%}

{%- endif %}
{%- endmacro -%}
