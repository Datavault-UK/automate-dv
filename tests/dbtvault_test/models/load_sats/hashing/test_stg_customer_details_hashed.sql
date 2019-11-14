{{- config(materialized='table', schema='stg', enabled=true, tags='load_sats')   -}}

{%- set source_table = source('test', 'stg_customer_details')                       -%}

{{  dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                          (['CUSTOMER_ID', 'CUSTOMER_NAME',
                          'CUSTOMER_PHONE', 'CUSTOMER_DOB'],
                          'CUSTOMER_HASHDIFF', true)]) -}},

{{  dbtvault.add_columns(source_table,
                         [('LOADDATE', 'EFFECTIVE_FROM')])                           }}

{{- dbtvault.from(source_table)                                                      }}