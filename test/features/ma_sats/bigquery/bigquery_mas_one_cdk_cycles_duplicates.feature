Feature: [BQ-MAS-1CD-D] Multi Active Satellites
  Loading in cycles using separate manual loads of MAS behaviour with duplicates and one CDK
  This is a series of 4 day loading cycles testing different duplicate record loads
  and different hashdiff configurations, i.e. incl. PK and CDK, excl. CDK, excl. PK and CDK

  @fixture.multi_active_satellite_cycle
  Scenario: [BQ-MAS-1CD-D-01] Load over several cycles with a mix of duplicate record change cases
    Given the RAW_STAGE stage is empty
    And the MULTI_ACTIVE_SATELLITE ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1244 | 2019-01-01     | 2019-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 2 ===================
    # Between-load duplicates (or identical subsequent loads)
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-01-02     | 2019-01-02 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-01-02     | 2019-01-02 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1233 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1224 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1234 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1244 | 2019-01-02     | 2019-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 3 ===================
    # Change of count/cdk/payload (and hashdiff) + intra-load duplicates
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 4 ===================
    # Between-load + intra-load duplicates
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-04     | 2019-01-04 | *      |

    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALBERT\|\|17-214-233-1211')  | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1222')    | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1223') | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1233') | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1214')   | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1224')   | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1234')   | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1244')   | Jenny         | 17-214-233-1244 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALBERT\|\|17-214-233-1311')  | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1312')    | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1322')    | Beth          | 17-214-233-1322 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1313') | Charley       | 17-214-233-1313 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1323') | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA\|\|17-214-233-1214')   | Jenna         | 17-214-233-1214 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA\|\|17-214-233-1224')   | Jenna         | 17-214-233-1224 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA\|\|17-214-233-1234')   | Jenna         | 17-214-233-1234 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA\|\|17-214-233-1244')   | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |

  @fixture.multi_active_satellite_cycle
  Scenario: [BQ-MAS-1CD-D-02] Load over several cycles with no CDK in HASHDIFF and a mix of duplicate record change cases
    Given the RAW_STAGE stage is empty
    And the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1244 | 2019-01-01     | 2019-01-01 | *      |
    And I stage the STG_CUSTOMER_NO_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat

    # ================ DAY 2 ===================
    # Between-load duplicates (or identical subsequent loads)
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-01-02     | 2019-01-02 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-01-02     | 2019-01-02 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1233 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1224 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1234 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1244 | 2019-01-02     | 2019-01-02 | *      |
    And I stage the STG_CUSTOMER_NO_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat

    # ================ DAY 3 ===================
    # Change of count/cdk/payload (and hashdiff) + intra-load duplicates
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |
    And I stage the STG_CUSTOMER_NO_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat

    # ================ DAY 4 ===================
    # Between-load + intra-load duplicates
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-04     | 2019-01-04 | *      |

    And I stage the STG_CUSTOMER_NO_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF table should contain expected data
      | CUSTOMER_PK | HASHDIFF               | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALBERT')  | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1002') | md5('1002\|\|BETH')    | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1002') | md5('1002\|\|BETH')    | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY') | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY') | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY') | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY')   | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY')   | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY')   | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('1010\|\|JENNY')   | Jenny         | 17-214-233-1244 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALBERT')  | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1002') | md5('1002\|\|BETH')    | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1002') | md5('1002\|\|BETH')    | Beth          | 17-214-233-1322 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY') | Charley       | 17-214-233-1313 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY') | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA')   | Jenna         | 17-214-233-1214 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA')   | Jenna         | 17-214-233-1224 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA')   | Jenna         | 17-214-233-1234 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('1010\|\|JENNA')   | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |

  @fixture.multi_active_satellite_cycle
  Scenario: [BQ-MAS-1CD-D-03] Load over several cycles with no PK nor CDK in HASHDIFF and a mix of duplicate record change cases
    Given the RAW_STAGE stage is empty
    And the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1244 | 2019-01-01     | 2019-01-01 | *      |
    And I stage the STG_CUSTOMER_NO_PK_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat

    # ================ DAY 2 ===================
    # Between-load duplicates (or identical subsequent loads)
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-01-02     | 2019-01-02 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-01-02     | 2019-01-02 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Charley       | 17-214-233-1233 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1224 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1234 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1244 | 2019-01-02     | 2019-01-02 | *      |
    And I stage the STG_CUSTOMER_NO_PK_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat

    # ================ DAY 3 ===================
    # Change of count/cdk/payload (and hashdiff) + intra-load duplicates
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |
    And I stage the STG_CUSTOMER_NO_PK_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat

    # ================ DAY 4 ===================
    # Between-load + intra-load duplicates
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1001        | Albert        | 17-214-233-1311 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beth          | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1313 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1323 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1214 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1224 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1234 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenna         | 17-214-233-1244 | 2019-01-04     | 2019-01-04 | *      |

    And I stage the STG_CUSTOMER_NO_PK_CDK_HASHDIFF data
    And I load the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF table should contain expected data
      | CUSTOMER_PK | HASHDIFF       | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALBERT')  | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1002') | md5('BETH')    | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1002') | md5('BETH')    | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('CHARLEY') | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('CHARLEY') | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1003') | md5('CHARLEY') | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('JENNY')   | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('JENNY')   | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('JENNY')   | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1010') | md5('JENNY')   | Jenny         | 17-214-233-1244 | 2019-01-01     | 2019-01-01 | *      |
      | md5('1001') | md5('ALBERT')  | Albert        | 17-214-233-1311 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1002') | md5('BETH')    | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1002') | md5('BETH')    | Beth          | 17-214-233-1322 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1003') | md5('CHARLEY') | Charley       | 17-214-233-1313 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1003') | md5('CHARLEY') | Charley       | 17-214-233-1323 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('JENNA')   | Jenna         | 17-214-233-1214 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('JENNA')   | Jenna         | 17-214-233-1224 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('JENNA')   | Jenna         | 17-214-233-1234 | 2019-01-03     | 2019-01-03 | *      |
      | md5('1010') | md5('JENNA')   | Jenna         | 17-214-233-1244 | 2019-01-03     | 2019-01-03 | *      |