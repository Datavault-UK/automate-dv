{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'incremental']) }}

{%- set src_pk = ['PART_PK', 'PART_PK', 'PART_PK']                                              -%}
{%- set src_nk = ['PART_ID', 'PART_ID', 'PART_ID']                                              -%}
{%- set src_ldts = 'LOADDATE'                                                                   -%}
{%- set src_source = 'SOURCE'                                                                   -%}

{%- set tgt_pk = ['PART_PK', 'BINARY(16)', 'PART_PK']                                           -%}
{%- set tgt_nk = ['PART_ID', 'NUMBER(38,0)', 'PARTKEY']                                         -%}
{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                                             -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                                         -%}

{%- set source = [ref('stg_parts_hashed'),
                  ref('stg_supplier_hashed'),
                  ref('stg_lineitem_hashed')]                                                   -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                                                 }}






