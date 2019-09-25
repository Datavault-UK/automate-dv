{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{{ snow_vault.gen_hashing([('BOOKING_REF', 'BOOKING_PK'),
                           ('CUSTOMER_ID', 'CUSTOMER_PK'),
                           (['CUSTOMER_ID', 'BOOKING_REF'],'CUSTOMER_BOOKING_PK'),
                           (['CUSTOMER_ID', 'NATIONALITY', 'PHONE'], 'BOOK_CUSTOMER_HASHDIFF'),
                           (['BOOKING_REF', 'BOOKING_DATE', 'DEPARTURE_DATE', 'PRICE', 'DESTINATION'], 'BOOK_BOOKING_HASHDIFF')]) -}},

{{ snow_vault.add_columns([('BOOKING_REF', 'BOOKING_REF') ,
                           ('PRICE', 'PRICE'),
                           ('BOOKING_DATE', 'BOOKING_DATE'),
                           ('DEPARTURE_DATE', 'DEPARTURE_DATE'),
                           ('DESTINATION', 'DESTINATION'),
                           ('PHONE', 'PHONE'),
                           ('NATIONALITY', 'NATIONALITY'),
                           ('LOADDATE', 'LOADDATE'),
                           ('BOOKING_DATE', 'EFFECTIVE_FROM')]) }}

{{- snow_vault.staging_footer(source='STG_BOOKING', source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_booking') }}