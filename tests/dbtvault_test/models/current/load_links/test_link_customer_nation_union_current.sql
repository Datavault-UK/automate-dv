{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_links', 'current'])     -}}

{#- {%- set source = [ref('test_stg_sap_customer_hashed_links_current'),
                  ref('test_stg_crm_customer_hashed_links_current'),
                  ref('test_stg_web_customer_hashed_links_current')]                                -%}

{%- set src_pk = 'CUSTOMER_NATION_PK'                                                       -%}
{%- set src_fk = ['CUSTOMER_PK', 'NATION_PK']                                               -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_pk = [src_pk, 'BINARY(16)', src_pk]                                             -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}

{{ dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                          tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                          source)                                                            }} -#}

{{ dbtvault.link(var('src_pk'), var('src_fk'), var('src_ldts'),
                 var('src_source'), var('source')) }}