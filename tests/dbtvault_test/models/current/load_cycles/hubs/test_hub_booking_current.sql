{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_cycles_current', 'current']) -}}

{#- {%- set source = [ref('test_stg_booking_hashed_current')]                                       -%}

{%- set src_pk = 'BOOKING_PK'                                                           -%}
{%- set src_nk = 'BOOKING_REF'                                                          -%}
{%- set src_ldts = 'LOADDATE'                                                           -%}
{%- set src_source = 'SOURCE'                                                           -%}

{%- set tgt_pk = source                                                                 -%}
{%- set tgt_nk = source                                                                 -%}
{%- set tgt_ldts = source                                                               -%}
{%- set tgt_source = source                                                             -%}

{{ dbtvault.hub_template(src_pk, src_nk, src_ldts, src_source,
                         tgt_pk, tgt_nk, tgt_ldts, tgt_source,
                         source)                                                         }} -#}

{{ dbtvault.hub(var('src_pk'), var('src_nk'), var('src_ldts'),
                var('src_source'), var('source') )}}