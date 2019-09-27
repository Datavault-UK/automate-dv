{{config(materialized='incremental', schema ='VLT', enabled=true, tags=['static', 'incremental'])}}

{%- set src_pk = ['INVENTORY_ALLOCATION_PK']                                          -%}
{%- set src_fk = [['PART_PK', 'SUPPLIER_PK', 'LINEITEM_PK']]                          -%}
{%- set src_source = 'SOURCE'                                                         -%}
{%- set src_ldts = 'LOADDATE'                                                         -%}

{%- set tgt_cols = ['INVENTORY_ALLOCATION_PK',
                    'PART_PK', 'SUPPLIER_PK', 'LINEITEM_PK',
                    'LOADDATE', 'SOURCE']                                             -%}

{%- set tgt_pk = ['INVENTORY_ALLOCATION_PK', 'BINARY(16)', 'INVENTORY_ALLOCATION_PK'] -%}
{%- set tgt_fk = [['PART_PK', 'BINARY(16)', 'PART_PK'],
                  ['SUPPLIER_PK', 'BINARY(16)', 'SUPPLIER_PK'],
                  ['LINEITEM_PK', 'BINARY(16)', 'LINEITEM_PK']]                       -%}

{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                                   -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                               -%}

{%- set source = [ref('stg_orders_hashed') ]                                      -%}

{{ dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                           tgt_cols, tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                           source) }}