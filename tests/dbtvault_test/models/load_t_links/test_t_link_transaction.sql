{{- config(materialized='incremental', schema='vlt', enabled=true, tags='t_link') -}}

{%- set source = [ref('test_t_link_transaction_hashed')] -%}

{%- set src_pk = 'TRANSACTION_PK' -%}
{%- set src_fk = 'CUSTOMER_PK' -%}
{%- set src_payload = ['TRANSACTION_NUMBER', 'TRANSACTION_DATE', 'TYPE', 'AMOUNT'] -%}
{%- set src_eff = 'EFFECTIVE_FROM' -%}
{%- set src_ldts = 'LOADDATE' -%}
{%- set src_source = 'SOURCE' -%}

{%- set tgt_pk = source -%}
{%- set tgt_fk = source -%}
{%- set tgt_payload = source -%}
{%- set tgt_eff = source -%}
{%- set tgt_ldts = source -%}
{%- set tgt_source = source -%}

{{ dbtvault.t_link_template(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source,
                            tgt_pk, tgt_fk, tgt_payload, tgt_eff, tgt_ldts, tgt_source,
                            source) }}