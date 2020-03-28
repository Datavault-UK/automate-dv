{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'current']) -}}

{%- set source_table = source('test_current', 'stg_supplier_current')                             -%}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK'),
                        ('SUPPLIER_ID', 'SUPPLIER_PK')])                          -}},

{{ dbtvault.add_columns(source_table)                                              }}

{{ dbtvault.from(source_table)                                                     }}




