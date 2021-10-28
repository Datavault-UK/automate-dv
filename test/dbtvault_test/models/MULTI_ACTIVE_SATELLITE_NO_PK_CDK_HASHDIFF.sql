{{ config(materialized='vault_insert_by_rank', rank_column='DBTVAULT_RANK', rank_source_models='STG_CUSTOMER_NO_PK_CDK_HASHDIFF') }}
    {{ dbtvault.ma_sat(src_pk='CUSTOMER_PK', src_cdk=['CUSTOMER_PHONE'], src_hashdiff='HASHDIFF', 
                         src_payload=['CUSTOMER_NAME'], src_eff='EFFECTIVE_FROM', 
                         src_ldts='LOAD_DATE', src_source='SOURCE', 
                         source_model='STG_CUSTOMER_NO_PK_CDK_HASHDIFF') }}