-- depends_on: {{ ref(var('link')) }}
{{ dbtvault.eff_sat(var('src_pk'), var('src_dfk'), var('src_sfk'), var('src_ldts'),
                    var('src_eff_from'), var('eff_start_date'), var('eff_end_date'),
                    var('src_source'), var('link'), var('source'))                               }}