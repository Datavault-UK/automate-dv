{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'current']) -}}

{%- set source_table = source('test_current', 'stg_eff_sat_current')                      -%}

SELECT

{{ dbtvault.add_columns(source_table)                                                      }}

{{ dbtvault.from(source_table)                                                             }}