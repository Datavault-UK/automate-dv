{%- set yaml_metadata -%}
source_model: raw_source
src_pk: CUSTOMER_PK
src_nk:
  - CUSTOMER_ID
  - CUSTOMER_NAME
src_ldts: LOADDATE
src_source: RECORD_SOURCE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{%- set source_model = metadata_dict['source_model'] -%}
{%- set src_pk = metadata_dict['src_pk'] -%}
{%- set src_nk = metadata_dict['src_nk'] -%}
{%- set src_ldts = metadata_dict['src_ldts'] -%}
{%- set src_source = metadata_dict['src_source'] -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}