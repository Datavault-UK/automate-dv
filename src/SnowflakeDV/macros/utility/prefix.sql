{%- macro prefix(columns, prefix_str) -%}

{%- for column in columns -%}
        {{ log("Outside: " ~ column, true) }}

    {%- if column.children -%}

        {{ log("Inside: " ~ column, true) }}
        {{ loop(column.children) }}

    {%- else -%}

        {{ log("else: " ~ column, true) }}

    {%- endif -%}

{%- endfor -%}

{%- endmacro -%}