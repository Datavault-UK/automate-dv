{{
  config(
    materialized='vault_insert_by_period',
    timestamp_field='load_dts',
    period='day',
    start_date='2020-01-01',
    stop_date='2020-01-05'
  )
}}

{%- set src_payload -%}
- val
{%- endset -%}

{{
  dbtvault_bq.sat(
    src_pk='ENTITY_HK',
    src_hashdiff='SAT_HASHDIFF',
    src_payload=fromyaml(src_payload),
    src_eff='EFFECTIVE_FROM',
    src_ldts='load_dts',
    src_source='rec_src',
    source_model='hstg_seed_insert_vault_by_period'
  )
}}