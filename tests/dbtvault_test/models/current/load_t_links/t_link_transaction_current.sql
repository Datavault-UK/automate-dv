{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['load_tlinks', 'current']) -}}

{{ dbtvault.t_link(var('src_pk'), var('src_fk'), var('src_payload'), var('src_eff'),
                   var('src_ldts'), var('src_source'), var('source')) }}