{{- config(materialized='incremental', schema='vlt', enabled=true, tags=['feature', 'current']) -}}

{{ dbtvault.eff_sat(var('src_pk'), var('src_ldts'), var('src_eff'),
                    var('src_source'), var('source'))                    }}