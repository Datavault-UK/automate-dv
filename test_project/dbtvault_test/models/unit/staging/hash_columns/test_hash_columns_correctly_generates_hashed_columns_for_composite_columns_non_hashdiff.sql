{%- set yaml_metadata -%}
columns:
  BOOKING_PK: BOOKING_REF
  CUSTOMER_DETAILS:
    - "ADDRESS"
    - "PHONE"
    - "NAME"
{%- endset -%}
{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ dbtvault.hash_columns(columns=metadata_dict['columns']) }}