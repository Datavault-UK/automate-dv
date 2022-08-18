def feature_sub_types():
    return {
        'hubs': {
            'main': [
                'hubs'
            ],
            'comp_pk': [
                'hubs_comp_pk'
            ],
            'incremental': [
                'hubs_incremental'
            ],
            'mat': [
                'hubs_period_mat',
                'hubs_rank_mat'
            ]
        },
        'links': {
            'main': [
                'links',
            ],
            'comp_pk': [
                'links_comp_pk'
            ],
            'incremental': [
                'links_incremental'
            ],
            'mat': [
                'links_period_mat',
                'links_rank_mat'
            ]
        },
        't_links': {
            'main': [
                't_links',
            ],
            'comp_pk': [
                't_links_comp_pk'
            ],
            'incremental': [
                't_links_incremental'
            ],
            'mat': [
                't_links_period_mat',
                't_links_rank_mat'
            ]
        },
        'sats': {
            'main': [
                'sats',
            ],
            'cycles': [
                'sats_cycles'
            ],
            'incremental': [
                'sats_incremental'
            ],
            'pm': [
                'sats_period_mat_base',
                'sats_period_mat_other'
                'sats_period_mat_inferred_range',
                'sats_period_mat_provided_range',
                'sats_daily',
                'sats_monthly'
            ],
            'rank': [
                'sats_rank_mat'
            ]
        },
        'eff_sats': {
            'main': [
                'eff_sats',
                'eff_sats_multi_part'
            ],
            'auto': [
                'eff_sats_auto_end_dating_detail_base',
                'eff_sats_auto_end_dating_detail_inc',
                'eff_sats_auto_end_dating_incremental'
            ],
            'disabled': [
                'eff_sats_disabled_end_dating',
                'eff_sats_disabled_end_dating_closed_records',
                'eff_sats_disabled_end_dating_incremental'
            ],
            'mat': [
                'eff_sats_period_mat',
                'eff_sats_rank_mat'
            ]
        },
        'ma_sats': {
            '1cdk': [
                'mas_one_cdk_0_base',
                'mas_one_cdk_1_inc',
                'mas_one_cdk_base_sats'
            ],
            '1cdk_cycles': [
                'mas_one_cdk_base_sats_cycles',
                'mas_one_cdk_cycles_duplicates'
            ],
            '2cdk': [
                'mas_two_cdk_0_base',
                'mas_two_cdk_1_inc',
                'mas_two_cdk_base_sats'
            ],
            '2cdk_cycles': [
                'mas_two_cdk_base_sats_cycles',
                'mas_two_cdk_cycles_duplicates'
            ],
            'incremental': [
                'mas_one_cdk_incremental',
                'mas_two_cdk_incremental'
            ],
            'pm': [
                'mas_period_mat',
                'mas_one_cdk_period_duplicates',
                'mas_two_cdk_period_duplicates'
            ],
            'rm': [
                'mas_rank_mat',
                'mas_one_cdk_base_sats_rank_mat'
            ],
            'rm_dup': [
                'mas_one_cdk_rank_duplicates',
                'mas_two_cdk_rank_duplicates'
            ]
        },
        'xts': {
            'main': [
                'xts',
                'xts_comp_pk'
            ],
            'incremental': [
                'xts_incremental'
            ]
        },
        'pit': {
            'main': [
                'pit'
            ],
            '1sat_base': [
                'pit_one_sat_base',
            ],
            '1sat_inc': [
                'pit_one_sat_inc'
            ],
            '2sat': [
                'pit_two_sat_base',
                'pit_two_sat_inc'
            ]
        },
        'bridge': {
            'inc': [
                'bridge_incremental'
            ],
            '1link': [
                'bridge_one_hub_one_link'
            ],
            '2link': [
                'bridge_one_hub_two_links'
            ],
            '3link': [
                'bridge_one_hub_three_links'
            ]
        },
    }
