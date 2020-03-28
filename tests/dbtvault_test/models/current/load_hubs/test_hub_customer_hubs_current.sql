{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['feature', 'current']) -}}

{{ dbtvault.hub(var('src_pk'), var('src_nk'), var('src_ldts'),
                var('src_source'), var('source'))                                   }}