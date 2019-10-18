{#- Copyright 2019 Business Thinking LTD. trading as Datavault

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}
{%- macro create_tgt_cols(src_pk, src_nk, src_ldts, src_source,
                          tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                          source) -%}

{%- set tgt_cols_dict = {'tgt_pk': (src_pk, tgt_pk, dbtvault.check_relation(tgt_pk[0])),
                         'tgt_nk': (src_nk, tgt_nk, dbtvault.check_relation(tgt_nk[0])),
                         'tgt_ldts': (src_ldts, tgt_ldts, dbtvault.check_relation(tgt_ldts[0])),
                         'tgt_source': (src_source, tgt_source, dbtvault.check_relation(tgt_source[0]))} -%}

{%- set tgt_cols_output = {'tgt_pk': '',
                           'tgt_nk': '',
                           'tgt_ldts': '',
                           'tgt_source': ''} -%}

{%- set src_cols_list = dbtvault.get_col_list([src_pk, src_nk, src_ldts, src_source]) -%}

    {%- set columns = adapter.get_columns_in_relation(source[0]) -%}
    {%- set column_names = columns | map(attribute='name') | list -%}

    {%- for col in tgt_cols_dict -%}

        {%- set src_col = tgt_cols_dict[col][0] -%}
        {%- set tgt_col = tgt_cols_dict[col][1] -%}
        {%- set is_relation = tgt_cols_dict[col][2] -%}

        {%- if is_relation -%}
            {%- if src_col in column_names -%}
                {%- set col_type = columns | selectattr('name', "equalto", src_col) | map(attribute='data_type') | list -%}
                {%- set _ = tgt_cols_output.update({col: [src_col, col_type[0], src_col]}) -%}
            {%- endif -%}
        {%- else -%}
            {%- set _ = tgt_cols_output.update({col: tgt_col}) -%}
        {%- endif -%}

    {% endfor %}
    {{ log(tgt_cols_output, true) }}
    {{ return(tgt_cols_output) }}

{%- endmacro -%}