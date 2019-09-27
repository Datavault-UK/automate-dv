{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')             -}}

{{ dbtvault.gen_hashing([('CUSTOMER_REF', 'CUSTOMER_PK'),
                         ('NATION_KEY', 'NATION_PK'),
                         (['CUSTOMER_REF', 'NATION_KEY'], 'CUSTOMER_NATION_PK')])              }},

{{ dbtvault.add_columns([('CUSTOMER_REF', 'CUSTOMER_REF'),
                         ('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE')])                                                }}

{{- dbtvault.staging_footer(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_crm_customer') }}


