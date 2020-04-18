{{- config(materialized='table', schema='stg', enabled=true, tags=['feature', 'deprecated']) -}}

{%- set source_table = source('test_deprecated', 'stg_customer_hubs_deprecated')                        -%}

{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK')]) -}},

{{ dbtvault.add_columns(source_table,
                        [('LOADDATE', 'EFFECTIVE_FROM')])                          }}

{{ dbtvault.from(source_table)                                                     }}






