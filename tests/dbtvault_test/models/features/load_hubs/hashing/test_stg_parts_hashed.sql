{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set source_table = source('test', 'stg_parts')                                -%}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK')])                                  -}},

{{ dbtvault.add_columns(source_table)                                              }}

{{ dbtvault.from(source_table)                                                     }}





