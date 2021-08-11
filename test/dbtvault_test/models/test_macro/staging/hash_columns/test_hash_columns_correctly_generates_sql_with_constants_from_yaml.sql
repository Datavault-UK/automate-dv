{%- set yaml_metadata -%}
columns:
  BOOKING_PK: BOOKING_REF
  CUSTOMER_PK:
    - CUSTOMER_ID
    - '!9999-12-31'
  CUSTOMER_BOOKING_PK:
    - CUSTOMER_ID
    - BOOKING_REF
    - TO_DATE('9999-12-31')
  BOOK_CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - PHONE
      - NATIONALITY
      - CUSTOMER_ID
  BOOK_BOOKING_HASHDIFF:
    is_hashdiff: true
    columns:
      - BOOKING_REF
      - TO_DATE('9999-12-31')
      - '!STG'
      - BOOKING_DATE
      - DEPARTURE_DATE
      - PRICE
      - DESTINATION
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.hash_columns(columns=metadata_dict['columns']) }}