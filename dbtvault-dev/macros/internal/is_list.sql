{%- macro is_list(obj) -%}

    {%- if obj is iterable and obj is not string and obj is not mapping and obj is not none and obj is defined and obj -%}
        {%- do return(true) -%}
    {%- else -%}
        {%- do return(false) -%}
    {%- endif -%}

{%- endmacro -%}