{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_cycles_current', 'current']) -}}

{{ dbtvault.link(var('src_pk'), var('src_fk'), var('src_ldts'),
                 var('src_source'), var('source')) }}