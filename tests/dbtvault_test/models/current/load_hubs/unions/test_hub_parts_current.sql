{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['feature', 'current']) -}}

{%- set source = [ref('test_stg_parts_hashed_current'),
                  ref('test_stg_supplier_hashed_current'),
                  ref('test_stg_lineitem_hashed_current')]                                      -%}

{%- set src_pk = 'PART_PK'                                                              -%}
{%- set src_nk = 'PART_ID'                                                              -%}
{%- set src_ldts = 'LOADDATE'                                                           -%}
{%- set src_source = 'SOURCE'                                                           -%}

{%- set tgt_pk = source                                                                 -%}
{%- set tgt_nk = source                                                                 -%}
{%- set tgt_ldts = source                                                               -%}
{%- set tgt_source = source                                                             -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                                         }}

