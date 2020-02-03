{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'current']) -}}

{%- set source_table = source('test_current', 'stg_parts_current')                                -%}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK')])                                  -}},

{{ dbtvault.add_columns(source_table)                                              }}

{{ dbtvault.from(source_table)                                                     }}





