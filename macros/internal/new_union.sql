{#- Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-#}

{%- macro new_union(src_pk, src_nk, src_ldts, src_source, tgt_pk, source) -%}

    SELECT {{ dbtvault.prefix([src_pk, src_nk, src_ldts, src_source], 'src')}},
    LAG({{ src_source }}, 1)
    OVER(PARTITION by {{ tgt_pk }}
    ORDER BY {{ tgt_pk }}) AS FIRST_SOURCE
    FROM (

 {%- set letters='abcdefghijklmnopqrstuvwxyz' -%}

      {%- set iterations = source|length -%}

      {%- for src in range(iterations) -%}
      {%- set letter = letters[loop.index0] %}
      {{ dbtvault.single(src_pk, src_nk, src_ldts, src_source,
                         source[loop.index0], letter) -}}

      {% if not loop.last %}
      UNION
      {%- endif -%}
      {%- endfor %}
      ) AS src
{%- endmacro -%}