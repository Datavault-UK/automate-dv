/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro alias_all(columns=none, prefix=none) -%}

    {{- adapter.dispatch('alias_all', 'dbtvault')(columns=columns, prefix=prefix) -}}

{%- endmacro %}

{%- macro default__alias_all(columns, prefix) -%}

{%- if dbtvault.is_list(columns) -%}

    {%- set processed_columns = [] -%}

    {%- for col in columns -%}
        {%- if col | lower not in processed_columns | map('lower') | list -%}

            {{ dbtvault.alias(alias_config=col, prefix=prefix) }}
            {%- if not loop.last -%} , {% endif -%}

            {%- if col is mapping -%}
                {%- if col['source_column'] | lower and col['alias'] | lower -%}
                    {%- do processed_columns.append(col['source_column']) -%}
                {% endif -%}
            {%- else -%}
                {%- do processed_columns.append(col) -%}
            {% endif -%}
        {% endif -%}
    {%- endfor -%}

{%- elif columns is string -%}

{{ dbtvault.alias(alias_config=columns, prefix=prefix) }}

{%- else -%}

    {%- if execute -%}
        {{ exceptions.raise_compiler_error("Invalid columns object provided. Must be a list or a string.") }}
    {%- endif %}

{%- endif %}

{%- endmacro -%}