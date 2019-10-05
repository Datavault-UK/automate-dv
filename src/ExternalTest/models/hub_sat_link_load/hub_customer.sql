{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'incremental']) }}

{%- set src_pk = 'CUSTOMER_PK'                                                                  -%}
{%- set src_nk = 'CUSTOMER_ID'                                                                  -%}
{%- set src_ldts = 'LOADDATE'                                                                   -%}
{%- set src_source = 'SOURCE'                                                                   -%}

{%- set tgt_cols = ['CUSTOMER_PK', 'CUSTOMER_ID', 'SOURCE', 'LOADDATE']                         -%}

{%- set tgt_pk = ['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_PK']                                   -%}
{%- set tgt_nk = ['CUSTOMER_ID', 'NUMBER(38,0)', 'CUSTOMER_ID']                                 -%}
{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                                             -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                                         -%}

{%- set source = [ref('stg_orders_hashed')]                                                     -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                                                 }}






