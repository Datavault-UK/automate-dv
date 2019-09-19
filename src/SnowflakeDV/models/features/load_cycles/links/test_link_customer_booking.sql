{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set src_pk = 'CUSTOMER_BOOKING_PK'                                    -%}
{%- set src_nk = ['CUSTOMER_PK', 'BOOKING_PK']                            -%}
{%- set src_ldts = 'LOADDATE'                                             -%}
{%- set src_source = 'SOURCE'                                             -%}

{%- set tgt_cols = [src_pk, src_nk[0], src_nk[1], src_ldts, src_source]   -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                           -%}
{%- set tgt_nk = [[src_nk[0], 'BINARY(16)', src_nk[0]],
                  [src_nk[1], 'BINARY(16)', src_nk[1]]]                   -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                           -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]               -%}

{%- set hash_model = [ref('test_stg_booking_hashed')]                     -%}

{{ snow_vault.hub_template(src_pk, src_nk, src_ldts, src_source,
                           tgt_cols, tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                           hash_model) }}