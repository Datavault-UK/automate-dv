{{ config(materialized='view') }}
    {{ automate_dv.stage(include_source_columns=none,
                           source_model='raw_stage_seed',
                           derived_columns={'EFFECTIVE_FROM': 'LOAD_DATE'},
                           null_columns={},
                           hashed_columns={'CUSTOMER_PK': 'CUSTOMER_ID', 'HASHDIFF': {'is_hashdiff': True, 'columns': ['CUSTOMER_ID', 'CUSTOMER_PHONE', 'CUSTOMER_NAME']}},
                           ranked_columns={}) }}