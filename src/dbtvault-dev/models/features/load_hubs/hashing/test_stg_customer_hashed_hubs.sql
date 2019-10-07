{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')                  -}}

{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK')]) -}},

{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'),
                         ('CUSTOMER_DOB', 'CUSTOMER_DOB'),
                         ('CUSTOMER_NAME', 'CUSTOMER_NAME'),
                         ('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE'),
                         ('LOADDATE', 'EFFECTIVE_FROM')])                                           }}

{{- dbtvault.from(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_customer_hubs')     }}






