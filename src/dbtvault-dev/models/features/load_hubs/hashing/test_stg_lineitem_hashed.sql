{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')          -}}

{%- set source_table = source('test', 'stg_lineitem')                                      -%}

{{ dbtvault.multi_hash([('ORDER_ID', 'ORDER_PK'),
                         ('PART_ID', 'PART_PK'),
                         ('SUPPLIER_ID', 'SUPPLIER_PK'),
                         ('LINENUMBER', 'LINEITEM_PK')])                                   -}},

{{ dbtvault.add_columns(source_table, [])                                                   }}

{{- dbtvault.from(source_table)                                                             }}


