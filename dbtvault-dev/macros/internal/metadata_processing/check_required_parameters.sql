{%- macro check_required_parameters() -%}

    {%- set ns = namespace(missing_parameters=[]) -%}

    {%- if kwargs is not none -%}

        {%- for k, v in kwargs.items() %}
            {%- do ns.missing_parameters.append(k) if v is none -%}
        {%- endfor -%}

        {%- if ns.missing_parameters -%}
            {{- exceptions.raise_compiler_error("Required parameter(s) missing or none in '{}': {}".format(this, ns.missing_parameters | join(", "))) -}}
        {%- endif -%}
    {%- endif -%}

{%- endmacro -%}