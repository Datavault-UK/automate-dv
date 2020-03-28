{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'deprecated']) -}}

{%- set source_table = source('test_deprecated', 'stg_supplier_deprecated')                             -%}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK'),
                        ('SUPPLIER_ID', 'SUPPLIER_PK')])                          -}},

{{ dbtvault.add_columns(source_table)                                              }}

{{ dbtvault.from(source_table)                                                     }}




