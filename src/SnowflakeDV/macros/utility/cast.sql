{%- macro cast(columns) -%}


{#- If a string or list -#}
{%- if columns is iterable -%}

    {#- If only single string provided -#}
    {%- if columns is string -%}

        {{columns}}

    {%- else -%}

        {%- for column in columns -%}

            {#- If triple has been provided [COLUMN, CAST_TYPE, ALIAS] -#}
            {% if column|length == 3 %}
                CAST({{ column[0] }} AS {{ column[1] }}) AS {{ column[2] }}

            {#- Output String if just a string -#}
            {%- elif column is string -%}
                {{column}}


            {%- else -%}

                {#- Output String if single-item list -#}
                {%- if column|length == 1 -%}
                    {{column|first}}

                {#- Recurse if containing further nested lists -#}
                {%- elif column is iterable -%}
                    {{ snow_vault.cast(column)}}

                {%- endif -%}

            {%- endif -%}

            {#- Add trailing comma if not last -#}
            {%- if not loop.last -%} , {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}

