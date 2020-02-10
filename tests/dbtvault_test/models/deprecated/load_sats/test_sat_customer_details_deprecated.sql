{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_sats', 'deprecated']) -}}

{%- set source = [ref('test_stg_customer_details_hashed_deprecated')]                              -%}

{%- set src_pk = 'CUSTOMER_PK'                                                          -%}
{%- set src_hashdiff = 'CUSTOMER_HASHDIFF'                                              -%}
{%- set src_payload = ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'CUSTOMER_PHONE']               -%}

{%- set src_eff = 'EFFECTIVE_FROM'                                                      -%}
{%- set src_ldts = 'LOADDATE'                                                           -%}
{%- set src_source = 'SOURCE'                                                           -%}

{%- set tgt_pk = source                                                                 -%}
{%- set tgt_hashdiff = [src_hashdiff , 'BINARY(16)', 'CUSTOMER_HASHDIFF']                        -%}
{%- set tgt_payload = [[src_payload[0], 'VARCHAR(60)', 'CUSTOMER_NAME'],
                       [src_payload[1], 'DATE', 'CUSTOMER_DOB'],
                       [src_payload[2], 'VARCHAR(15)', 'CUSTOMER_PHONE']]                        -%}
{%- set tgt_eff = source                                                                -%}
{%- set tgt_ldts = source                                                               -%}
{%- set tgt_source = source                                                             -%}


{{  dbtvault.sat_template(src_pk, src_hashdiff, src_payload,
                          src_eff, src_ldts, src_source,
                          tgt_pk, tgt_hashdiff, tgt_payload,
                          tgt_eff, tgt_ldts, tgt_source,
                          source)                                                        }}







