{%- macro prefix(columns, prefix_str, alias_target) -%}
   {# BQ Change: Look locally for BQ compatible macro #}
    {{- adapter.dispatch('prefix', packages = ['dbtvault_bq'])(columns=columns, prefix_str=prefix_str, alias_target=alias_target) -}}

{%- endmacro -%}

{# BQ Change: snowflake__ -> default__ #}
{%- macro default__prefix(columns=none, prefix_str=none, alias_target='source') -%}

    {%- if columns and prefix_str -%}

        {%- for col in columns -%}

            {%- if col is mapping -%}

                {%- if alias_target == 'source' -%}

                    {{- dbtvault_bq.prefix([col['source_column']], prefix_str) -}}

                {%- elif alias_target == 'target' -%}

                    {{- dbtvault_bq.prefix([col['alias']], prefix_str) -}}

                {%- else -%}

                    {{- dbtvault_bq.prefix([col['source_column']], prefix_str) -}}

                {%- endif -%}

                {%- if not loop.last -%} , {% endif %}

            {%- else -%}

                {%- if col is iterable and col is not string -%}

                    {{- dbtvault_bq.prefix(col, prefix_str) -}}

                {%- elif col is not none -%}

                    {{- prefix_str}}.{{col.strip() -}}
                {% else %}

                    {%- if execute -%}
                        {{- exceptions.raise_compiler_error("Unexpected or missing configuration for '" ~ this ~ "' Unable to prefix columns.") -}}
                    {%- endif -%}
                {%- endif -%}

                {{- ', ' if not loop.last -}}

            {%- endif -%}

        {%- endfor -%}

    {%- else -%}

        {%- if execute -%}
            {{- exceptions.raise_compiler_error("Invalid parameters provided to prefix macro. Expected: (columns [list/string], prefix_str [string]) got: (" ~ columns ~ ", " ~ prefix_str ~ ")") -}}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}