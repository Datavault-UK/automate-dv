{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') }}

{%- set source_table = source('test', 'stg_crm_customer')                        -%}

{{ dbtvault.multi_hash([('CUSTOMER_REF', 'CUSTOMER_PK'),
                         ('NATION_KEY', 'NATION_PK'),
                         (['CUSTOMER_REF', 'NATION_KEY'], 'CUSTOMER_NATION_PK')]) }},

{{ dbtvault.add_columns(source_table)                                             }}

{{- dbtvault.from(source_table)                                                   }}


