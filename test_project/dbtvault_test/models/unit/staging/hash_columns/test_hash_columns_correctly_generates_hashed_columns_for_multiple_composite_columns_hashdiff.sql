{%- set yaml_metadata -%}
columns:
  BOOKING_PK: BOOKING_REF
  CUSTOMER_DETAILS:
    is_hashdiff: true
    columns:
      - PHONE
      - NATIONALITY
      - CUSTOMER_ID
  ORDER_DETAILS:
    is_hashdiff: true
    columns:
      - ORDER_DATE
      - ORDER_AMOUNT
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{ dbtvault.hash_columns(columns=metadata_dict['columns']) }}