{{config(materialized='incremental', schema ='VLT', enabled=true, tags=['static', 'incremental'])}}

{%- set src_table = ['src_stg.v_stg_orders']                                                    -%}

{%- set src_pk = ['LINK_CUSTOMER_NATION_PK']                                                    -%}
{%- set src_fk = ['CUSTOMER_PK', 'CUSTOMER_NATION_PK']                                          -%}
{%- set src_ldts = 'LOADDATE'                                                                   -%}
{%- set src_source = 'SOURCE'                                                                   -%}

{%- set tgt_cols = ['LINK_CUSTOMER_NATION_PK', 'CUSTOMER_PK', 'CUSTOMER_NATION_PK',
                    'LOADDATE', 'SOURCE']                                                       -%}

{%- set tgt_pk = ['LINK_CUSTOMER_NATION_PK', 'BINARY(16)', 'LINK_CUSTOMER_NATION_PK']           -%}

{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_PK'],
                  ['CUSTOMER_NATION_PK', 'BINARY(16)', 'CUSTOMER_NATION_PK']]                   -%}
{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                                             -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                                         -%}

{%- set hash_model = [ref('stg_orders_hashed')]                                                 -%}

{{ snow_vault.link_template(src_table, src_pk, src_fk, src_ldts, src_source,
                           tgt_cols, tgt_pk, tgt_fk, tgt_ldts, tgt_source, hash_model) }}