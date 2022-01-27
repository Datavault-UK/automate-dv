{%- macro as_constant(column_str=none) -%}

    {{- adapter.dispatch('as_constant', 'dbtvault')(column_str=column_str) -}}

{%- endmacro %}

{%- macro default__as_constant(column_str) -%}

    {%- if column_str is not none and column_str is string and column_str -%}

        {%- if column_str | first == "!" -%}
        
            {{- return("'" ~ column_str[1:] ~ "'") -}}
        
        {%- else -%}
        
            {%- if dbtvault.is_expression(column_str) -%}

                {{- return(column_str) -}}

            {%- else -%}

                {{- return(dbtvault.escape_column_names(column_str)) -}}

            {%- endif -%}

        {%- endif -%}
    {%- else -%}
        {%- if execute -%}
            {{ exceptions.raise_compiler_error("Invalid columns_str object provided. Must be a string and not null.") }}
        {%- endif %}
    {%- endif -%}

{%- endmacro -%}