{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{{ dbtvault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         (['CUSTOMER_ID', 'CUSTOMER_NAME', 'CUSTOMER_DOB'], 'CUST_CUSTOMER_HASHDIFF')]) -}},

{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'),
                         ('CUSTOMER_DOB', 'CUSTOMER_DOB'),
                         ('CUSTOMER_NAME', 'CUSTOMER_NAME'),
                         ('LOADDATE', 'LOADDATE'),
                         ('LOADDATE', 'EFFECTIVE_FROM')]) }}

{{- dbtvault.staging_footer(source='STG_CUSTOMER', source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_customer') }}






