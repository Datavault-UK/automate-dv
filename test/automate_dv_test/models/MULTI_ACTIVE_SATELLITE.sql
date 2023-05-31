{{ config(materialized='incremental') }}
    {{ automate_dv.ma_sat(src_pk='CUSTOMER_PK', src_cdk=['CUSTOMER_PHONE'], src_hashdiff='HASHDIFF', 
                            src_payload=['CUSTOMER_NAME'], 
                            src_eff='EFFECTIVE_FROM', 
                            src_extra_columns=none, 
                            src_ldts='LOAD_DATE', src_source='SOURCE', 
                            source_model='STG_CUSTOMER') }}