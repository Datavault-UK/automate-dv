{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set cur_date = "TO_DATE('2019-05-04')" -%}

{{ snow_vault.gen_hashing([('BOOKING_REF', 'BOOKING_PK'),
                           ('CUSTOMER_ID', 'CUSTOMER_PK'),
                           (['CUSTOMER_ID', 'BOOKING_REF'],'CUSTOMER_BOOKING_PK'),
                           (['BOOKING_REF', 'PRICE', 'DEPARTURE_DATE', 'DESTINATION'], 'BOOK_CUSTOMER_HASHDIFF'),
                           (['CUSTOMER_ID', 'PHONE', 'NATIONALITY'], 'BOOK_BOOKING_HASHDIFF')]) -}},

{{ snow_vault.add_columns([('BOOKING_REF', 'BOOKING_REF') ,
                           ('PRICE', 'PRICE'),
                           ('DEPARTURE_DATE', 'DEPARTURE_DATE'),
                           ('DESTINATION', 'DESTINATION'),
                           ('PHONE', 'PHONE'),
                           ('NATIONALITY', 'NATIONALITY'),
                           (cur_date, 'EFFECTIVE_FROM')]) }},


{{- snow_vault.staging_footer(cur_date, 'STG_BOOKING', 'DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_booking') }}






