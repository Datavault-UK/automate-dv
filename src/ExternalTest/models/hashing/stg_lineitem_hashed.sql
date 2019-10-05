{{- config(materialized='view', schema='STG', tags=['static', 'incremental'], enabled=true) -}}

{%- set source_table = source('test', 'lineitem')                                           -%}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK')])                                             }},

{{ dbtvault.add_columns(source_table,
                        [('!TPCH', 'SOURCE'),
                         ('CURRENT_DATE()', 'EFFECTIVE_FROM')])                              }}

{{ dbtvault.from(source_table)                                                               }}