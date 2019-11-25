{{- config(materialized='table', schema='stg', enabled=true, tags='load_tlinks')     -}}

{%- set source_table = source('test', 'stg_transaction')                             -%}

{{  dbtvault.multi_hash([(['CUSTOMER_ID', 'TRANSACTION_NUMBER'], 'TRANSACTION_PK'),
                         ('CUSTOMER_ID', 'CUSTOMER_PK')])                            -}},

{{  dbtvault.add_columns(source_table,
                         [('TRANSACTION_DATE', 'EFFECTIVE_FROM')])                            }}

{{- dbtvault.from(source_table)                                                       }}