{{ config(materialized='incremental') }}
        {{ dbtvault.hub('CUSTOMER_PK', 'CUSTOMER_ID', 'LOAD_DATE',
                          'SOURCE', 'STG_CUSTOMER')   }}