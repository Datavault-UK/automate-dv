{{- config(materialized='table', schema='stg', enabled=true, tags=['load_links', 'deprecated']) -}}

{%- set source_table = source('test_deprecated', 'stg_customer_links_deprecated')                       -%}

{{ dbtvault.multi_hash([('CUSTOMER_ID', 'CUSTOMER_PK'),
                         ('NATION_ID', 'NATION_PK'),
                         (['CUSTOMER_ID', 'NATION_ID'], 'CUSTOMER_NATION_PK')])   -}},

{{ dbtvault.add_columns(source_table)                                              }}

{{- dbtvault.from(source_table)                                                    }}


