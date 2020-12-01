{{
  config(
    materialized = 'view',
    )
}}

{%- set hashed_columns -%}
ENTITY_HK: entity_id
SAT_HASHDIFF:
  hashdiff: true
  columns:
    - val
{%- endset -%}

{%- set derived_columns -%}
REC_SRC: '!seed_insert_vault_by_period'
EFFECTIVE_FROM: 'load_dts'
{%- endset -%}


{{
  dbtvault_bq.stage(
    include_source_columns=true,
    source_model='seed_insert_vault_by_period',
    hashed_columns=fromyaml(hashed_columns),
    derived_columns=fromyaml(derived_columns)
  )

}}