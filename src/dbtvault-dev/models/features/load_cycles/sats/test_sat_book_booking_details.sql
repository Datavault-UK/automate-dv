{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set source = [ref('test_stg_booking_hashed')]                                       -%}

{%- set src_pk = 'BOOKING_PK'                                                           -%}
{%- set src_hashdiff = 'BOOK_BOOKING_HASHDIFF'                                          -%}
{%- set src_payload = ['PRICE', 'BOOKING_DATE', 'DEPARTURE_DATE', 'DESTINATION']        -%}

{%- set src_eff = 'EFFECTIVE_FROM'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                           -%}
{%- set src_source = 'SOURCE'                                                           -%}

{%- set tgt_pk = source                                                                 -%}
{%- set tgt_hashdiff = [ src_hashdiff , 'BINARY(16)', 'HASHDIFF']                       -%}
{%- set tgt_payload = source                                                            -%}

{%- set tgt_eff = source                                                                -%}
{%- set tgt_ldts = source                                                               -%}
{%- set tgt_source = source                                                             -%}

{{  dbtvault.sat_template(src_pk, src_hashdiff, src_payload,
                          src_eff, src_ldts, src_source,
                          tgt_pk, tgt_hashdiff, tgt_payload,
                          tgt_eff, tgt_ldts, tgt_source,
                          source)                                                        }}







