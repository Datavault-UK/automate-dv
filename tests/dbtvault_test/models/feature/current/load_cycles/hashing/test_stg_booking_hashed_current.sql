{{- config(materialized='table', schema='vlt', enabled=true, tags=['load_cycles_current', 'current'])                                            -}}

{%- set source_table = source('test_current', 'stg_booking_current')                                                                            -%}

{{ dbtvault.stage(source_table, var('hashed_columns'), var('added_columns')) }}