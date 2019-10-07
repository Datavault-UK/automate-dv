{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')             -}}

{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         ('NATION_ID', 'NATION_PK'),
                         (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK')])                }},

{{ dbtvault.add_columns([('CUSTOMER_ID', 'CUSTOMER_ID'),
                         ('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE')])                                                }}

{{- dbtvault.from(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_sap_customer') }}


