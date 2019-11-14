{{- config(materialized='incremental', schema='vlt', enabled=true, tags='load_cyles') -}}

{%- set source = [ref('test_stg_booking_hashed'),
                  ref('test_stg_customer_hashed')]                                      -%}

{%- set src_pk = 'CUSTOMER_PK'                                                          -%}
{%- set src_nk = 'CUSTOMER_ID'                                                          -%}
{%- set src_ldts = 'LOADDATE'                                                           -%}
{%- set src_source = 'SOURCE'                                                           -%}

{%- set tgt_pk = source                                                                 -%}
{%- set tgt_nk = source                                                                 -%}
{%- set tgt_ldts = source                                                               -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                            -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                                         }}


