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

{%- macro is_multi_source(source, src_pk, src_fk, src_ldts, src_source) -%}

{%- if source is iterable and source is not string -%}
    {%- set multi_source = [] -%}
    {%- for element in source -%}

        {%- set _ = multi_source.append(ref(element)) -%}

    {%- endfor -%}

    {%- set is_union = dbtvault.is_union(multi_source) -%}
    {%- set source_col = dbtvault.source_columns(src_pk, src_fk, src_ldts, src_source,
                                                 multi_source, is_union) -%}

    {{- return(source_col) -}}

{%- else -%}

    {%- set source = [ref(var('source'))] -%}
    {%- set is_union = dbtvault.is_union(source) -%}
    {%- set source_col = dbtvault.source_columns(src_pk, src_fk, src_ldts, src_source,
                                                 source, is_union) -%}

    {{- return(source_col) -}}

{%- endif -%}

{%- endmacro -%}