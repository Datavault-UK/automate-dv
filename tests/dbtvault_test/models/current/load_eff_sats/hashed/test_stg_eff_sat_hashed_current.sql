{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'current']) -}}

{%- set source_table = source('test_current', 'stg_eff_sat_current')                      -%}

SELECT

{{ dbtvault.add_columns(source_table)                                                      }},

TO_DATE('9999-12-31') AS END_DATETIME

{{ dbtvault.from(source_table)                                                             }}