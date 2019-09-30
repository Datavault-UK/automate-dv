{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')                  -}}

{{  dbtvault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK'),
                          (['CUSTOMER_ID', 'CUSTOMER_NAME',
                          'CUSTOMER_PHONE', 'CUSTOMER_DOB'], 'CUSTOMER_HASHDIFF')])                -}},

{{  dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'),
                          ('CUSTOMER_NAME', 'CUSTOMER_NAME'),
                          ('CUSTOMER_DOB', 'CUSTOMER_DOB'),
                          ('CUSTOMER_PHONE', 'CUSTOMER_PHONE'),
                          ('LOADDATE', 'EFFECTIVE_FROM'),
                          ('LOADDATE', 'LOADDATE'),
                          ('SOURCE', 'SOURCE')])                                                    }}

{{- dbtvault.staging_footer(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_customer_details')  }}


