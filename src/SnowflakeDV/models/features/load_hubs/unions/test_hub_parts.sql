{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set src_pk = ['PART_PK', 'PART_PK', 'PART_PK']                          -%}
{%- set src_nk = ['PART_ID', 'PART_ID', 'PART_ID']                          -%}
{%- set src_ldts = 'LOADDATE'                                               -%}
{%- set src_source = 'SOURCE'                                               -%}

{%- set tgt_cols = [src_pk[0], src_nk[0], src_ldts, src_source]             -%}

{%- set tgt_pk = [src_pk[0], 'BINARY(16)', src_pk[0]]                       -%}
{%- set tgt_nk = [src_nk[0], 'NUMBER(38,0)', src_nk[0]]                     -%}
{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                -%}

{%- set hash_model = [ref('test_stg_parts_hashed'),
                      ref('test_stg_supplier_hashed'),
                      ref('test_stg_lineitem_hashed')]                      -%}



{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                           tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                           hash_model)                                       }}

