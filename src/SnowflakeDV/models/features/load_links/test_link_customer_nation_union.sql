{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature')     -}}

{%- set src_pk = ['CUSTOMER_NATION_PK', 'CUSTOMER_NATION_PK', 'CUSTOMER_NATION_PK']         -%}
{%- set src_fk = [['CUSTOMER_PK', 'NATION_PK'], ['CUSTOMER_PK', 'NATION_PK'],
                  ['CUSTOMER_PK', 'NATION_PK']]                                             -%}
{%- set src_ldts = 'LOADDATE'                                                               -%}
{%- set src_source = 'SOURCE'                                                               -%}

{%- set tgt_cols = ['CUSTOMER_NATION_PK', 'CUSTOMER_PK', 'NATION_PK', src_ldts, src_source] -%}

{%- set tgt_pk = [src_pk[0], 'BINARY(16)', src_pk[0]]                                       -%}
{%- set tgt_fk = [['CUSTOMER_PK', 'BINARY(16)', 'CUSTOMER_FK'],
                  ['NATION_PK', 'BINARY(16)', 'NATION_FK']]                                 -%}

{%- set tgt_ldts = [src_ldts, 'DATE', src_ldts]                                             -%}
{%- set tgt_source = [src_source, 'VARCHAR(15)', src_source]                                -%}

{%- set source = [ref('test_stg_sap_customer_hashed_links'),
                      ref('test_stg_crm_customer_hashed_links'),
                      ref('test_stg_web_customer_hashed_links')]                            -%}

{{ dbtvault.link_template(src_pk, src_fk, src_ldts, src_source,
                          tgt_cols, tgt_pk, tgt_fk, tgt_ldts, tgt_source,
                          source)                                                            }}