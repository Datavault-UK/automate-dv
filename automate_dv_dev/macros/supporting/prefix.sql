/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro prefix(columns, prefix_str, alias_target) -%}

    {{- adapter.dispatch('prefix', 'automate_dv')(columns=columns,
                                               prefix_str=prefix_str,
                                               alias_target=alias_target) -}}

{%- endmacro -%}

{%- macro default__prefix(columns=none, prefix_str=none, alias_target='source') -%}

    {%- set processed_columns = [] -%}

    {%- if columns and prefix_str -%}

        {%- for col in columns -%}

            {%- if col | lower not in processed_columns | map('lower') | list -%}

                {%- if col is mapping -%}

                    {%- if alias_target == 'source' -%}

                        {{- automate_dv.prefix([col['source_column']], prefix_str) -}}

                        {%- do processed_columns.append(col['source_column']) -%}

                    {%- elif alias_target == 'target' -%}

                        {{- automate_dv.prefix([col['alias']], prefix_str) -}}

                         {%- do processed_columns.append(col['alias']) -%}

                    {%- else -%}

                        {{- automate_dv.prefix([col['source_column']], prefix_str) -}}

                        {%- do processed_columns.append(col['source_column']) -%}

                    {%- endif -%}

                    {%- if not loop.last -%} , {% endif %}

                {%- else -%}

                    {%- if col is iterable and col is not string -%}

                        {{- automate_dv.prefix(col, prefix_str) -}}

                        {%- do processed_columns.append(col) -%}

                    {%- elif col is not none -%}

                        {{- prefix_str}}.{{col.strip() -}}

                        {%- do processed_columns.append(col) -%}
                    {% else %}

                        {%- if execute -%}
                            {{- exceptions.raise_compiler_error("Unexpected or missing configuration for '" ~ this ~ "' Unable to prefix columns.") -}}
                        {%- endif -%}
                    {%- endif -%}

                    {{- ', ' if not loop.last -}}

                {%- endif -%}
            {%- endif -%}

        {%- endfor -%}

    {%- else -%}

        {%- if execute -%}
            {{- exceptions.raise_compiler_error("Invalid parameters provided to prefix macro. Expected: (columns [list/string], prefix_str [string]) got: (" ~ columns ~ ", " ~ prefix_str ~ ")") -}}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}
