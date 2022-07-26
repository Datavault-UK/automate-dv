{%- macro null_columns(columns=none) -%}

    {% if columns %}
        {%- set new_column_list = [] -%}
        {%- set required = "{},\n".format(columns['REQUIRED']) | indent(4) -%}
        {%- set optional = columns['OPTIONAL'] | indent(4) -%}
        {%- set original_name = "CUSTOMER_ID_ORIGINAL" -%}
        {%- set original = "{} AS {},\n".format(required, original_name) | indent(4) -%}
        {%- set new_name = "CUSTOMER_ID_NEW" -%}
        {%- set new = "IFNULL({}, '-1') AS {}".format(required, new_name) | indent(4) -%}

        {%- do new_column_list.append(required) -%}
        {%- do new_column_list.append(original) -%}
        {%- do new_column_list.append(new) -%}

        {%- do return(new_column_list) -%}
    {%- else -%}
    {%- endif %}

{%- endmacro -%}