{{- config(materialized='table', schema='test_vlt', enabled=true, tags='feature')      -}}

{{ dbtvault.multi_hash([('PART_ID', 'PART_PK')])                                      -}},

{{ dbtvault.add_columns([('PART_ID', 'PART_ID'),
                         ('PART_NAME', 'PART_NAME'),
                         ('PART_TYPE', 'PART_TYPE'),
                         ('PART_SIZE', 'PART_SIZE'),
                         ('PART_RETAILPRICE', 'PART_RETAILPRICE'),
                         ('LOADDATE', 'LOADDATE'),
                         ('SOURCE', 'SOURCE')])                                         }}

{{- dbtvault.from(source_table='DV_PROTOTYPE_DB.SRC_TEST_STG.test_stg_parts') }}


