{{- config(materialized='view', schema='STG', tags=['static', 'incremental'], enabled=true) -}}

{% set source_table = source('test', 'parts')                                               -%}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK')])                                             }},

{{ dbtvault.add_columns(source_table)                                                       -}}

{{ dbtvault.from(source_table)                                                               }}