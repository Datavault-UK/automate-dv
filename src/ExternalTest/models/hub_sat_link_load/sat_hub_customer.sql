{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'incremental'])}}

{%- set src_pk = 'CUSTOMER_PK'                                                     -%}
{%- set src_hash = 'CUSTOMER_HASHDIFF'                                             -%}

{%- set src_nk = ['CUSTOMER_NAME', 'CUSTOMER_ADDRESS',
                  'CUSTOMER_PHONE', 'CUSTOMER_ACCBAL',
                  'CUSTOMER_MKTSEGMENT', 'CUSTOMER_COMMENT']                       -%}

{%- set src_ldts = 'LOADDATE'                                                      -%}
{%- set src_eff = 'EFFECTIVE_FROM'                                                 -%}
{%- set src_source = 'SOURCE'                                                      -%}

{%- set tgt_cols = ['CUSTOMER_HASHDIFF', 'CUSTOMER_PK', 'CUSTOMER_NAME',
                    'CUSTOMER_ADDRESS', 'CUSTOMER_PHONE', 'CUSTOMER_ACCBAL',
                    'CUSTOMER_MKTSEGMENT', 'CUSTOMER_COMMENT',
                    'LOADDATE', 'EFFECTIVE_FROM', 'SOURCE']                        -%}

{%- set tgt_pk = ['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_PK']                      -%}
{%- set tgt_hash = ['CUSTOMER_HASHDIFF', 'BINARY(16)', 'HASHDIFF']                 -%}

{%- set tgt_nk = [['CUSTOMER_NAME', 'VARCHAR(25)', 'CUSTOMER_NAME'],
                  ['CUSTOMER_ADDRESS', 'VARCHAR(40)', 'CUSTOMER_ADDRESS'],
                  ['CUSTOMER_PHONE', 'VARCHAR(15)', 'CUSTOMER_PHONE'],
                  ['CUSTOMER_ACCBAL', 'NUMBER(12,1)', 'CUSTOMER_ACCBAL'],
                  ['CUSTOMER_MKTSEGMENT', 'VARCHAR(10)', 'CUSTOMER_MKTSEGMENT'],
                  ['CUSTOMER_COMMENT', 'VARCHAR(117)', 'CUSTOMER_COMMENT']]

                                                                                   -%}

{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                                -%}
{%- set tgt_eff = ['EFFECTIVE_FROM', 'DATE', 'EFFECTIVE_FROM']                     -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                            -%}


{%- set src_table = ['src_stg.v_stg_orders']                                       -%}

{%- set hash_model = ref('stg_orders_hashed')                                      -%}

{{ dbtvault.sat_template(src_pk, src_hash, src_nk, src_ldts, src_eff, src_source,
                           tgt_cols, tgt_pk, tgt_hash, tgt_nk, tgt_ldts, tgt_eff, tgt_source,
                           src_table, hash_model) }}