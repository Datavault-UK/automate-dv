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
{%- macro eff_sat(src_pk, src_dfk, src_sfk, src_ldts, src_eff_from, src_eff_to, src_source, link, source)-%}

{%- set source_cols = dbtvault.get_src_col_list([src_pk, src_ldts, src_eff_from, src_eff_to, src_source])-%}
{%- set max_date = "'" ~ '9999-12-31' ~ "'" -%}

WITH
{#- Reduce data set to size of stage table. #}
c AS (SELECT DISTINCT
            {{ dbtvault.prefix(source_cols, 'a') }}
            FROM {{ this }} AS a
            INNER JOIN {{ ref(source) }} AS b ON {{ dbtvault.prefix([src_pk], 'a') }}={{ dbtvault.prefix([src_pk], 'b') }}
            )
{# Find latest satellite for each pk in set c. -#}
, d as (SELECT
          {{ dbtvault.prefix(source_cols, 'c') }},
          CASE WHEN RANK()
          OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'c') }}
          ORDER BY {{ dbtvault.prefix([src_eff_from], 'c') }} DESC) = 1
          THEN 'Y' ELSE 'N' END AS CURR_FLG
        FROM c)
, p AS (
  SELECT q.*, {{ dbtvault.prefix([src_dfk], 'r') }}
  FROM {{ this }} AS q
  INNER JOIN {{ ref(link) }} AS r ON {{ dbtvault.prefix([src_pk], 'r') }}={{ dbtvault.prefix([src_pk], 'q') }}
  INNER JOIN {{ ref(source) }} AS s ON {{ dbtvault.prefix([src_dfk], 's') }}={{ dbtvault.prefix([src_dfk], 'r') }}
  AND {{ dbtvault.prefix([src_sfk], 's') }}<>{{ dbtvault.prefix([src_sfk], 'r') }})
, t as (
  SELECT
    p.*,
    CASE WHEN RANK()
    OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'p') }}
    ORDER BY {{ dbtvault.prefix([src_eff_from], 'p') }} DESC) = 1
    THEN 'Y' ELSE 'N' END AS CURR_FLG
  FROM p)

SELECT DISTINCT {{ dbtvault.prefix(source_cols, 'e') }}
FROM {{ ref(source) }} AS e
{% if is_incremental() -%}
LEFT JOIN (
    SELECT {{ dbtvault.prefix(source_cols, 'd')}}
    FROM d
    WHERE d.CURR_FLG = 'Y' AND {{ dbtvault.prefix([src_eff_to], 'd') }}=TO_DATE({{ max_date }})
    ) AS eff
ON {{ dbtvault.prefix([src_pk], 'eff') }}={{ dbtvault.prefix([src_pk], 'e') }}
WHERE {{ dbtvault.prefix([src_pk], 'eff') }} IS NULL
UNION
SELECT
  t.CUSTOMER_ORDER_PK, t.EFFECTIVE_FROM, u.LOADDATE, u.EFFECTIVE_FROM AS EFFECTIVE_TO, u.SOURCE
FROM t
INNER JOIN DBT_VAULT.TEST_STG.TEST_STG_EFF_SAT_HASHED_CURRENT AS u ON t.ORDER_FK=u.ORDER_FK
{%- endif -%}

{% endmacro %}