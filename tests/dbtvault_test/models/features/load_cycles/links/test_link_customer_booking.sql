{{- config(materialized='incremental', schema='vlt', enabled=true, tags='load_cyles') -}}

{%- set source = [ref('test_stg_booking_hashed')]                                       -%}

{%- set src_pk = 'CUSTOMER_BOOKING_PK'                                                  -%}
{%- set src_fk = ['CUSTOMER_PK', 'BOOKING_PK']                                          -%}
{%- set src_ldts = 'LOADDATE'                                                           -%}
{%- set src_source = 'SOURCE'                                                           -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                         -%}
{%- set tgt_fk = [[src_fk[0], 'BINARY(16)', src_fk[0]],
                  [src_fk[1], 'BINARY(16)', src_fk[1]]]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                         -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                            -%}

{{ dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                          tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                          source)                                                        }}