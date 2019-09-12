{{config(materialized='incremental', schema='VLT', enabled=false, tags=['static', 'incremental'])}}

{%- set src_table = ['SRC_TEST_STG.STG_PART',
                     'SRC_TEST_STG.STG_PARTSUPP',
                     'SRC_TEST_STG.STG_LINEITEM']
                                                                          -%}

{%- set src_pk = ['PART_PK', 'PART_PK', 'PART_PK']                        -%}
{%- set src_nk = ['PARTKEY', 'PARTKEY', 'PARTKEY']                        -%}
{%- set src_source = 'SOURCE'                                             -%}
{%- set src_ldts = 'LOADDATE'                                             -%}

{%- set tgt_cols = ['PART_PK', 'PARTKEY', 'LOADDATE', 'SOURCE']           -%}
{%- set tgt_pk = ['PART_PK', 'BINARY(16)', 'PART_PK']                     -%}
{%- set tgt_nk = ['PARTKEY', 'NUMBER(38,0)', 'PARTKEY']                   -%}
{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                       -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                   -%}

{%- set hash_model = none                                                 -%}

{{ snow_vault.hub_template(src_table, src_pk, src_nk, src_ldts, src_source,
                           tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source, hash_model) }}






