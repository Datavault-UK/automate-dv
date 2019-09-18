{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set cur_date = 'CURRENT_DATE'-%}

{{ snow_vault.gen_hashing([('BOOKING_REF', 'BOOKING_PK'),
                           (['BOOKING_REF', 'CUSTOMER_ID', 'DEPARTURE_DATE', 'DESTINATION'], 'BOOKING_HASHDIFF')]) -}},

{{ snow_vault.add_columns([('PRICE', 'PRICE'),
                            ('DEPARTURE_DATE', 'DEPARTURE_DATE'),
                            ('DESTINATION', 'DESTINATION'),
                            (cur_date, 'EFFECTIVE_FROM')]) }},


{{- snow_vault.staging_footer(cur_date, 'STG_BOOKING', 'DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_booking') }}






