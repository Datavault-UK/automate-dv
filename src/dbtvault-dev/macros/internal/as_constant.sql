{%- macro as_constant(column_str=none) -%}

    {{- adapter.dispatch('as_constant', packages = ['dbtvault'])(column_str=column_str) -}}

{%- endmacro %}

{%- macro default__as_constant(column_str) -%}

    {% if column_str is not none %}

        {%- if column_str | first == "!" -%}
        
            {{- return("'" ~ column_str[1:] ~ "'") -}}
        
        {%- else -%}
        
            {{- return(column_str) -}}
        
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}