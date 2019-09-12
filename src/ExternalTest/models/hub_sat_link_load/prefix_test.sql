{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'incremental'])}}

{%- set src_table = ['src_stg.v_stg_orders']                              -%}
{%- set src_pk = ['CUSTOMER_PK']                                          -%}
{%- set src_nk = ['CUSTOMERKEY']                                          -%}
{%- set src_ldts = 'LOADDATE'                                             -%}
{%- set src_source = 'SOURCE'                                             -%}

{%- set tgt_cols = ['CUSTOMER_PK', 'CUSTOMERKEY', 'SOURCE', 'LOADDATE']   -%}
{%- set tgt_pk = ['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_PK']             -%}
{%- set tgt_nk = ['CUSTOMERKEY', 'NUMBER(38,0)', 'CUSTOMERKEY']           -%}
{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                       -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                   -%}


{{ snow_vault.prefix(tgt_cols, 'a') }}




