{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'current']) -}}

{%- set source_table = source('test_current', 'stg_customer_hubs_current')                        -%}

{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK')]) -}},

{{ dbtvault.add_columns(source_table,
                        [('LOADDATE', 'EFFECTIVE_FROM')])                          }}

{{ dbtvault.from(source_table)                                                     }}






