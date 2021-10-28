{{ config(materialized='view') }}
    {{ dbtvault.stage(include_source_columns=true,
                        source_model='raw_stage_seed',
                        derived_columns={'EFFECTIVE_FROM': 'LOAD_DATE'},
                        hashed_columns={'CUSTOMER_PK': 'CUSTOMER_ID', 'HASHDIFF': {'is_hashdiff': True, 'columns': ['CUSTOMER_NAME']}},
                        ranked_columns={'DBTVAULT_RANK': {'partition_by': 'CUSTOMER_ID', 'order_by': 'LOAD_DATE'}}) }}