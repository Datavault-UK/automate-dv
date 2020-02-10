{{- config(materialized='table', schema='stg', enabled=true, tags=['load_links', 'current']) }}

{%- set source_table = source('test_current', 'stg_crm_customer_current')                        -%}

{{ dbtvault.multi_hash([('CUSTOMER_REF', 'CUSTOMER_PK'),
                        ('CUSTOMER_REF', 'CUSTOMER_FK'),
                        ('NATION_KEY', 'NATION_PK'),
                        ('NATION_KEY', 'NATION_FK'),
                        (['CUSTOMER_REF', 'NATION_KEY'], 'CUSTOMER_NATION_PK')]) }},

{{ dbtvault.add_columns(source_table)                                             }}

{{- dbtvault.from(source_table)                                                   }}


