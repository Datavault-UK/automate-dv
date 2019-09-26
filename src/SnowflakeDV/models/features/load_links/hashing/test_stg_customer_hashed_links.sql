{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')                -}}

{{ dbtvault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         ('NATION_ID', 'NATION_PK'),
                         (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK')])                  -}},

{{ dbtvault.add_columns([('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE')])                                                   }}

{{- dbtvault.staging_footer(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_customer_links')  }}


