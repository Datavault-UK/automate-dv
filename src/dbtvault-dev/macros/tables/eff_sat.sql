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
{%- macro eff_sat(src_pk, src_ldts, src_eff, src_source, source)-%}

{%- set source_cols = dbtvault.get_src_col_list([src_pk, src_ldts, src_eff, src_source])-%}

SELECT DISTINCT {{ dbtvault.prefix(source_cols, 'd') }}, TO_DATE('9999-12-31') AS EFFECTIVE_TO
FROM {{ ref(source) }} as d
LEFT JOIN (
    SELECT
      {{ dbtvault.prefix(source_cols, 'c') }},
      CASE WHEN RANK()
      OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'c') }}
      ORDER BY {{ dbtvault.prefix([src_eff], 'c') }} DESC) = 1
      THEN 'Y' ELSE 'N' END AS CURR_FLG
    FROM (
        SELECT DISTINCT
        {{ dbtvault.prefix(source_cols, 'a') }}
        FROM {{ this }} AS a
        INNER JOIN {{ ref(source) }} AS b ON {{ dbtvault.prefix([src_pk], 'a') }}={{ dbtvault.prefix([src_pk], 'b') }}
        ) AS c
    ) AS eff
ON {{ dbtvault.prefix([src_pk], 'eff') }}={{ dbtvault.prefix([src_pk], 'd') }}
WHERE {{ dbtvault.prefix([src_pk], 'eff') }} IS NULL

{%- if is_incremental() -%}

AND eff.CURR_FLG = 'Y'

{%- endif -%}

{% endmacro %}