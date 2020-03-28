{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_cycles_current', 'current']) -}}

{{ dbtvault.sat(var('src_pk'), var('src_hashdiff'), var('src_payload'),
                var('src_eff'), var('src_ldts'), var('src_source'),
                var('source')) }}







