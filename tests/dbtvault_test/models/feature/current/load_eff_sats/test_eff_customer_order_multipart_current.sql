-- depends_on: {{ ref(var('link')) }}
{{ dbtvault.eff_sat(var('src_pk'), var('src_dfk'), var('src_sfk'), var('src_ldts'),
                    var('src_eff_from'), var('src_source'), var('link'), var('source_model')) }}