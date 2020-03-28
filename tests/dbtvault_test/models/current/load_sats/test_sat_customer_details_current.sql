{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_sats', 'current']) -}}

{{ dbtvault.alias({'source_column': 'CUSTOMER_HASHDIFF', 'alias': 'HASHDIFF'}) }}

{{ dbtvault.alias('CUSTOMER_HASHDIFF') }}

{{ dbtvault.alias_all([{'source_column': 'CUSTOMER_HASHDIFF', 'alias': 'HASHDIFF'},
                       {'source_column': 'BOOKING_HASHDIFF', 'alias': 'HASHDIFF'},
                       {'source_column': 'ORDER_HASHDIFF', 'alias': 'HASHDIFF'}]) }}

{{ dbtvault.alias_and_prefix_all([{'source_column': 'CUSTOMER_HASHDIFF', 'alias': 'HASHDIFF'},
                                  {'source_column': 'BOOKING_HASHDIFF', 'alias': 'HASHDIFF'},
                                  {'source_column': 'ORDER_HASHDIFF', 'alias': 'HASHDIFF'}],
                                 'c') }}

{{ dbtvault.alias_and_prefix_all(['CUSTOMER_HASHDIFF',
                                  {'source_column': 'BOOKING_HASHDIFF', 'alias': 'HASHDIFF'},
                                  'ORDER_HASHDIFF'],
                                  'c') }}

{{ dbtvault.sat(var('src_pk'), var('src_hashdiff'), var('src_payload'),
                var('src_eff'), var('src_ldts'), var('src_source'),
                var('source')) }}







