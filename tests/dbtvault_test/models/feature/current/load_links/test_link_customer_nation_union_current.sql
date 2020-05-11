{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_links', 'current'])     -}}

{{ dbtvault.multiperiod_link(var('src_pk'), var('src_fk'), var('src_ldts'),
                 var('src_source'), var('source')) }}