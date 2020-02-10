{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_cycles_current', 'current'])               -}}

{#- {%- set source = [ref('test_stg_customer_hashed_current')]                                                    -%}

{%- set src_pk = 'CUSTOMER_PK'                                                                        -%}
{%- set src_hashdiff = 'CUST_CUSTOMER_HASHDIFF'                                                       -%}
{%- set src_payload = ['CUSTOMER_DOB', 'CUSTOMER_NAME']                                               -%}

{%- set src_eff = 'EFFECTIVE_FROM'                                                                    -%}
{%- set src_ldts = 'LOADDATE'                                                                         -%}
{%- set src_source = 'SOURCE'                                                                         -%}

{%- set tgt_pk = source                                                                               -%}
{%- set tgt_hashdiff = [ src_hashdiff , 'BINARY', 'CUST_CUSTOMER_HASHDIFF']                                         -%}
{%- set tgt_payload = [[ src_payload[0] , 'DATE', 'DOB'], [ src_payload[1], 'VARCHAR(60)', 'CUSTOMER_NAME']]   -%}

{%- set tgt_eff = source                                                                              -%}
{%- set tgt_ldts = source                                                                             -%}
{%- set tgt_source = source                                                                           -%}

{{  dbtvault.sat_template(src_pk, src_hashdiff, src_payload,
                          src_eff, src_ldts, src_source,
                          tgt_pk, tgt_hashdiff, tgt_payload,
                          tgt_eff, tgt_ldts, tgt_source,
                          source)                                                                      }} -#}

{{ dbtvault.sat(var('src_pk'), var('src_hashdiff'), var('src_payload'),
                var('src_eff'), var('src_ldts'), var('src_source'),
                var('source')) }}






