/*
 *  Copyright (c) Business Thinking Ltd. 2019-2022
 *  This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro print_list(list_to_print=none, indent=4) -%}

    {%- for col_name in list_to_print -%}
        {{- col_name | indent(indent) -}}{{ ",\n    " if not loop.last }}
    {%- endfor -%}

{%- endmacro -%}