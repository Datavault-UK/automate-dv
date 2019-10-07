{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature') -}}

{%- set source_table = source('test', 'stg_sap_customer')                         -%}

{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         ('NATION_ID', 'NATION_PK'),
                         (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK')])    }},

{{ dbtvault.add_columns(source_table, [])                                          }}

{{- dbtvault.from(source_table)                                                    }}


