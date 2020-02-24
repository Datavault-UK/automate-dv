{#- Copyright 2020 Business Thinking LTD. trading as Datavault

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
{%- macro is_union(obj) -%}

{%- if obj is iterable and obj is not string -%}
    {%- set checked_relations = [] -%}
    {%- for source in obj -%}
        {%- set _ = checked_relations.append(dbtvault.check_relation(source)) -%}
    {%- endfor -%}

    {#- Not a union if only one source -#}
    {%- if checked_relations | length == 1 -%}

        {{- return(false) -}}

    {%- else -%}
    {#- Check all are relations -#}
        {%- set test_outcome = checked_relations | unique | list -%}

        {%- if test_outcome | length > 1 -%}

            {{- return(false) -}}

        {%- elif test_outcome[0] is sameas true -%}

            {{- return(true) -}}

        {%- else -%}

            {{- return(false) -}}

        {%- endif -%}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}