{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'current'])          -}}

{%- set source_table = source('test_current', 'stg_lineitem_current')                                      -%}

{{ dbtvault.multi_hash([('ORDER_ID', 'ORDER_PK'),
                        ('PART_ID', 'PART_PK'),
                        ('SUPPLIER_ID', 'SUPPLIER_PK'),
                        ('LINENUMBER', 'LINEITEM_PK')])                                    -}},

{{ dbtvault.add_columns(source_table)                                                       }}

{{ dbtvault.from(source_table)                                                              }}


