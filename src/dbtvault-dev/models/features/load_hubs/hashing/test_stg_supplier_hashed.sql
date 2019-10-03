{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')          -}}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK'),
                         ('SUPPLIER_ID', 'SUPPLIER_PK')])                                  -}},

{{ dbtvault.add_columns([('PART_ID', 'PART_ID'),
                         ('AVAILQTY', 'AVAILQTY'),
                         ('SUPPLYCOST ', 'SUPPLYCOST '),
                         ('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE')])                                             }}

{{- dbtvault.staging_footer(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_supplier')  }}


