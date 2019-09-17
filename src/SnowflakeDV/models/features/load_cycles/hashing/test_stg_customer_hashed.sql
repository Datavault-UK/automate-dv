{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{{ snow_vault.gen_hashing([('CUSTOMER_ID', 'CUSTOMER_PK'),
                           (['CUSTOMER_ID', 'CUSTOMER_DOB', 'CUSTOMER_NAME'], 'CUSTOMER_HASHDIFF')]) -}},

{{- snow_vault.staging_footer('CURRENT_DATE', 'CURRENT_DATE', 'STG_CUSTOMER', 'DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_customer') }}






