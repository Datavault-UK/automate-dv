{%- set yaml_metadata -%}
columns:
  BOOKING_PK: BOOKING_REF
  CUSTOMER_PK: CUSTOMER_ID
  CUSTOMER_BOOKING_PK:
    - CUSTOMER_ID
    - BOOKING_REF
  BOOK_CUSTOMER_HASHDIFF:
    columns:
      - PHONE
      - NATIONALITY
      - CUSTOMER_ID
  BOOK_BOOKING_HASHDIFF:
    columns:
      - BOOKING_REF
      - BOOKING_DATE
      - DEPARTURE_DATE
      - PRICE
      - DESTINATION
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.hash_columns(columns=metadata_dict['columns']) }}