{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')                       -}}

{%- set source_table = source('test', 'stg_customer')                                                   -%}

{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         (['CUSTOMER_ID', 'CUSTOMER_NAME', 'CUSTOMER_DOB'],
                         'CUST_CUSTOMER_HASHDIFF', true)])                                              -}},

{{ dbtvault.add_columns(source_table,
                        [('!STG_CUSTOMER', 'SOURCE'),
                         ('LOADDATE', 'EFFECTIVE_FROM')])                                                }}

{{ dbtvault.from(source_table)                                                                           }}






