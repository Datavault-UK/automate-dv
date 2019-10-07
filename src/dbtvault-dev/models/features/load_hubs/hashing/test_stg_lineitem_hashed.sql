{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')          -}}

{{ dbtvault.multi_hash([('ORDER_ID', 'ORDER_PK'),
                         ('PART_ID', 'PART_PK'),
                         ('SUPPLIER_ID', 'SUPPLIER_PK'),
                         ('LINENUMBER', 'LINEITEM_PK')])                                   -}},

{{ dbtvault.add_columns([('PART_ID', 'PART_ID'),
                         ('LINENUMBER', 'LINENUMBER'),
                         ('QUANTITY', 'QUANTITY'),
                         ('EXTENDED_PRICE', 'EXTENDED_PRICE'),
                         ('DISCOUNT', 'DISCOUNT'),
                         ('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE')])                                             }}

{{- dbtvault.from(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_lineitem')  }}


