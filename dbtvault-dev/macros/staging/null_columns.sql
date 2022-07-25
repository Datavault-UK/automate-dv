{%- macro null_columns(source_relation=none, columns=none) -%}

    {{- adapter.dispatch('null_columns', 'dbtvault')(source_relation=source_relation, columns=columns) -}}

{%- endmacro -%}


{%- macro default__null_columns(source_relation=none, columns=none) -%}

{%- if columns is mapping and columns is not none -%}

    {%- for col in columns -%}

        {%- set required = "{{ null_columns['REQUIRED'] }}" -%}
        {%- set original_name = "CUSTOMER_ID_ORIGINAL" -%}
        {%- set new_name = "CUSTOMER_ID_NEW" -%}

        {{- "{} AS {}".format(required, original_name | indent(4)) -}}
        {{- "IFNULL({}, '-1') AS {}".format(required, new_name | indent(4)) -}}

    {%- endfor -%}

{%- endif %}

{%- endmacro -%}