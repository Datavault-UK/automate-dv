{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set cur_date = 'CURRENT_DATE'-%}

{{ snow_vault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK'),
                           (['CUSTOMER_ID', 'CUSTOMER_DOB', 'CUSTOMER_NAME'], 'CUSTOMER_HASHDIFF')]) -}},

{{ snow_vault.add_columns([('CUSTOMER_DOB', 'CUSTOMER_DOB'),
                           ('CUSTOMER_NAME', 'CUSTOMER_NAME'),
                           (cur_date, 'EFFECTIVE_FROM')]) }},

{{- snow_vault.staging_footer(cur_date, 'STG_CUSTOMER', 'DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_customer') }}






