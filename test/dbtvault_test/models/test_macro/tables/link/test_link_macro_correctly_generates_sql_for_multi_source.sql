{%- set yaml_metadata -%}
source_model:
  - raw_source
  - raw_source_2
src_pk: CUSTOMER_PK
src_fk:
  - ORDER_FK
  - BOOKING_FK
src_ldts: LOADDATE
src_source: RECORD_SOURCE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set src_pk = metadata_dict['src_pk'] -%}
{%- set src_fk = metadata_dict['src_fk'] -%}
{%- set src_ldts = metadata_dict['src_ldts'] -%}
{%- set src_source = metadata_dict['src_source'] -%}

{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}