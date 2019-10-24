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
{%- macro create_tgt_cols() -%}

{%- set tgt_pk = kwargs['tgt_pk']|default(None, true) -%}
{%- set tgt_nk = kwargs['tgt_nk']|default(None, true) -%}
{%- set tgt_fk = kwargs['tgt_fk']|default(None, true) -%}
{%- set tgt_payload = kwargs['tgt_payload']|default(None, true) -%}
{%- set tgt_hashdiff = kwargs['tgt_hashdiff']|default(None, true) -%}
{%- set tgt_eff = kwargs['tgt_eff']|default(None, true) -%}
{%- set tgt_ldts = kwargs['tgt_ldts']|default(None, true) -%}
{%- set tgt_source = kwargs['tgt_source']|default(None, true) -%}

{%- set src_pk = kwargs['src_pk']|default(None, true) -%}
{%- set src_nk = kwargs['src_nk']|default(None, true) -%}
{%- set src_fk = kwargs['src_fk']|default(None, true) -%}
{%- set src_payload = kwargs['src_payload']|default(None, true) -%}
{%- set src_hashdiff = kwargs['src_hashdiff']|default(None, true) -%}
{%- set src_eff = kwargs['src_eff']|default(None, true) -%}
{%- set src_ldts = kwargs['src_ldts']|default(None, true) -%}
{%- set src_source = kwargs['src_source']|default(None, true) -%}

{%- set source = kwargs['source']|default(None, true) -%}

{%- set tgt_cols_dict = {'tgt_pk': (src_pk, tgt_pk, dbtvault.check_relation(tgt_pk[0])),
                         'tgt_nk': (src_nk, tgt_nk, dbtvault.check_relation(tgt_nk[0])),
                         'tgt_fk': (src_fk, tgt_fk, dbtvault.check_relation(tgt_fk[0])),
                         'tgt_payload': (src_payload, tgt_payload, dbtvault.check_relation(tgt_payload[0])),
                         'tgt_hashdiff': (src_hashdiff, tgt_hashdiff, dbtvault.check_relation(tgt_hashdiff[0])),
                         'tgt_eff': (src_eff, tgt_eff, dbtvault.check_relation(tgt_eff[0])),
                         'tgt_ldts': (src_ldts, tgt_ldts, dbtvault.check_relation(tgt_ldts[0])),
                         'tgt_source': (src_source, tgt_source, dbtvault.check_relation(tgt_source[0]))} -%}

{%- set tgt_cols_output = {'tgt_pk': '',
                           'tgt_nk': '',
                           'tgt_fk': '',
                           'tgt_payload': '',
                           'tgt_hashdiff': '',
                           'tgt_eff': '',
                           'tgt_ldts': '',
                           'tgt_source': ''} -%}

{%- set src_cols_list = dbtvault.get_col_list([src_pk, src_nk, src_fk,
                         src_payload, src_hashdiff, src_eff,
                         src_ldts, src_source] | reject("none") | list) -%}

{%- set columns = adapter.get_columns_in_relation(source[0]) -%}
{%- set column_names = columns | map(attribute='name') | list -%}

{%- for col in tgt_cols_dict -%}

    {%- set src_cols = tgt_cols_dict[col][0] -%}
    {%- set tgt_col = tgt_cols_dict[col][1] -%}
    {%- set is_relation = tgt_cols_dict[col][2] -%}
    {%- set src_col_list = [] -%}

    {%- if is_relation -%}
        {%- if src_cols is iterable and src_cols is not string -%}
            {%- for src_col in src_cols -%}
                {%- if src_col in column_names -%}
                    {%- set col_type = columns | selectattr('name', "equalto", src_col) | map(attribute='data_type') | list -%}
                    {%- set _ = src_col_list.append([src_col, col_type[0], src_col]) -%}
                {%- endif -%}
            {%- endfor -%}
        {%- else -%}
            {%- set col_type = columns | selectattr('name', "equalto", src_cols) | map(attribute='data_type') | list -%}
            {%- set _ = src_col_list.append([src_cols, col_type[0], src_cols]) -%}
        {%- endif -%}

        {%- if src_col_list | length > 1 -%}
            {%- set _ = tgt_cols_output.update({col: src_col_list}) -%}
        {%- else -%}
            {%- set _ = tgt_cols_output.update({col: src_col_list[0]}) -%}
        {%- endif -%}
    {%- else -%}
        {%- set _ = tgt_cols_output.update({col: tgt_col}) -%}
    {%- endif -%}

{% endfor %}

{{ return(tgt_cols_output) }}

{%- endmacro -%}