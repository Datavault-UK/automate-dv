{{ config(materialized='view') }}
        {{ dbtvault.stage(include_source_columns=true,
                            source_model='raw_stage_seed',
                            derived_columns=none,
                            hashed_columns={'CUSTOMER_PK': 'CUSTOMER_ID'},
                            ranked_columns={}) }}