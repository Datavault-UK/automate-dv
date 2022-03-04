Feature: [MAS-2CD-BSC] Multi Active Satellites
  Loading in cycles using separate manual loads of base satellites behaviour with two CDKs

  @fixture.multi_active_satellite_cycle
  Scenario: [MAS-2CD-BSC-01] Load over several cycles
    Given the RAW_STAGE_TWO_CDK stage is empty
    And the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 17-214-233-1215 | 123       | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         | 17-214-233-1213 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         | 17-214-233-1210 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         | 17-214-233-1216 | 123       | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # ================ DAY 3 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 17-214-233-1213 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 17-214-233-1218 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 17-214-233-1216 | 123       | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # ================ DAY 4 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 124       | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 123       | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 17-214-233-1217 | 123       | 2019-05-07     | 2019-05-07 | *      |
      | 1010        | Jenny         | 17-214-233-1218 | 123       | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                         | EXTENSION | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALBERT\|\|17-214-233-1211\|\|123')  | 123       | Albert        | 17-214-233-1211 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1214\|\|123')   | 123       | Jenny         | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1012') | md5('1012\|\|ALBERT\|\|17-214-233-1215\|\|123')  | 123       | Albert        | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BEAH\|\|17-214-233-1212\|\|123')    | 123       | Beah          | 17-214-233-1212 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1003') | md5('1003\|\|CHRIS\|\|17-214-233-1213\|\|123')   | 123       | Chris         | 17-214-233-1213 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1004') | md5('1004\|\|DAVID\|\|17-214-233-1210\|\|123')   | 123       | David         | 17-214-233-1210 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1216\|\|123')   | 123       | Jenny         | 17-214-233-1216 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1003') | md5('1003\|\|CLAIRE\|\|17-214-233-1213\|\|123')  | 123       | Claire        | 17-214-233-1213 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1005') | md5('1005\|\|ELWYN\|\|17-214-233-1218\|\|123')   | 123       | Elwyn         | 17-214-233-1218 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1006') | md5('1006\|\|FREIA\|\|17-214-233-1216\|\|123')   | 123       | Freia         | 17-214-233-1216 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212\|\|124')    | 124       | Beth          | 17-214-233-1212 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1007') | md5('1007\|\|GEOFF\|\|17-214-233-1219\|\|123')   | 123       | Geoff         | 17-214-233-1219 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1011') | md5('1011\|\|KAREN\|\|17-214-233-1217\|\|123')   | 123       | Karen         | 17-214-233-1217 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1218\|\|123')   | 123       | Jenny         | 17-214-233-1218 | 2019-05-07     | 2019-05-07 | *      |

  @fixture.multi_active_satellite_cycle
  Scenario: [MAS-2CD-BSC-02] Load over several cycles with Timestamps
    Given the RAW_STAGE_TWO_CDK_TS stage is empty
    And the MULTI_ACTIVE_SATELLITE_TWO_CDK_TS ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE_TWO_CDK_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 123       | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 123       | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | 1012        | Albert        | 17-214-233-1215 | 123       | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK_TS data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK_TS ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE_TWO_CDK_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 123       | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
      | 1003        | Chris         | 17-214-233-1213 | 123       | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
      | 1004        | David         | 17-214-233-1210 | 123       | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
      | 1010        | Jenny         | 17-214-233-1216 | 123       | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK_TS data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK_TS ma_sat

    # ================ DAY 3 ===================
    When the RAW_STAGE_TWO_CDK_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
      | 1003        | Claire        | 17-214-233-1213 | 123       | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
      | 1005        | Elwyn         | 17-214-233-1218 | 123       | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
      | 1006        | Freia         | 17-214-233-1216 | 123       | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK_TS data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK_TS ma_sat

    # ================ DAY 4 ===================
    When the RAW_STAGE_TWO_CDK_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 124       | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 123       | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |
      | 1011        | Karen         | 17-214-233-1217 | 123       | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK_TS data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK_TS ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                         | EXTENSION | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALBERT\|\|17-214-233-1211\|\|123')  | 123       | Albert        | 17-214-233-1211 | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1214\|\|123')   | 123       | Jenny         | 17-214-233-1214 | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | md5('1012') | md5('1012\|\|ALBERT\|\|17-214-233-1215\|\|123')  | 123       | Albert        | 17-214-233-1215 | 2019-05-04 11:14:54.396 | 2019-05-04 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BEAH\|\|17-214-233-1212\|\|123')    | 123       | Beah          | 17-214-233-1212 | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHRIS\|\|17-214-233-1213\|\|123')   | 123       | Chris         | 17-214-233-1213 | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DAVID\|\|17-214-233-1210\|\|123')   | 123       | David         | 17-214-233-1210 | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1216\|\|123')   | 123       | Jenny         | 17-214-233-1216 | 2019-05-05 11:14:54.396 | 2019-05-05 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CLAIRE\|\|17-214-233-1213\|\|123')  | 123       | Claire        | 17-214-233-1213 | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
      | md5('1005') | md5('1005\|\|ELWYN\|\|17-214-233-1218\|\|123')   | 123       | Elwyn         | 17-214-233-1218 | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
      | md5('1006') | md5('1006\|\|FREIA\|\|17-214-233-1216\|\|123')   | 123       | Freia         | 17-214-233-1216 | 2019-05-06 11:14:54.396 | 2019-05-06 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212\|\|124')    | 124       | Beth          | 17-214-233-1212 | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |
      | md5('1007') | md5('1007\|\|GEOFF\|\|17-214-233-1219\|\|123')   | 123       | Geoff         | 17-214-233-1219 | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |
      | md5('1011') | md5('1011\|\|KAREN\|\|17-214-233-1217\|\|123')   | 123       | Karen         | 17-214-233-1217 | 2019-05-07 11:14:54.396 | 2019-05-07 11:14:54.396 | *      |

  @fixture.multi_active_satellite_cycle
  @fixture.enable_sha
  Scenario: [MAS-2CD-BSC-03] Load over several cycles
    Given the RAW_STAGE_TWO_CDK stage is empty
    And the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 17-214-233-1215 | 123       | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         | 17-214-233-1213 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         | 17-214-233-1210 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         | 17-214-233-1216 | 123       | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # ================ DAY 3 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 17-214-233-1213 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 17-214-233-1218 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 17-214-233-1216 | 123       | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # ================ DAY 4 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 124       | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 123       | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 17-214-233-1217 | 123       | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                         | EXTENSION | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha('1001') | sha('1001\|\|ALBERT\|\|17-214-233-1211\|\|123')  | 123       | Albert        | 17-214-233-1211 | 2019-05-04     | 2019-05-04 | *      |
      | sha('1002') | sha('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-04     | 2019-05-04 | *      |
      | sha('1003') | sha('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-04     | 2019-05-04 | *      |
      | sha('1010') | sha('1010\|\|JENNY\|\|17-214-233-1214\|\|123')   | 123       | Jenny         | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | sha('1012') | sha('1012\|\|ALBERT\|\|17-214-233-1215\|\|123')  | 123       | Albert        | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | sha('1002') | sha('1002\|\|BEAH\|\|17-214-233-1212\|\|123')    | 123       | Beah          | 17-214-233-1212 | 2019-05-05     | 2019-05-05 | *      |
      | sha('1003') | sha('1003\|\|CHRIS\|\|17-214-233-1213\|\|123')   | 123       | Chris         | 17-214-233-1213 | 2019-05-05     | 2019-05-05 | *      |
      | sha('1004') | sha('1004\|\|DAVID\|\|17-214-233-1210\|\|123')   | 123       | David         | 17-214-233-1210 | 2019-05-05     | 2019-05-05 | *      |
      | sha('1010') | sha('1010\|\|JENNY\|\|17-214-233-1216\|\|123')   | 123       | Jenny         | 17-214-233-1216 | 2019-05-05     | 2019-05-05 | *      |
      | sha('1002') | sha('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-06     | 2019-05-06 | *      |
      | sha('1003') | sha('1003\|\|CLAIRE\|\|17-214-233-1213\|\|123')  | 123       | Claire        | 17-214-233-1213 | 2019-05-06     | 2019-05-06 | *      |
      | sha('1005') | sha('1005\|\|ELWYN\|\|17-214-233-1218\|\|123')   | 123       | Elwyn         | 17-214-233-1218 | 2019-05-06     | 2019-05-06 | *      |
      | sha('1006') | sha('1006\|\|FREIA\|\|17-214-233-1216\|\|123')   | 123       | Freia         | 17-214-233-1216 | 2019-05-06     | 2019-05-06 | *      |
      | sha('1002') | sha('1002\|\|BETH\|\|17-214-233-1212\|\|124')    | 124       | Beth          | 17-214-233-1212 | 2019-05-07     | 2019-05-07 | *      |
      | sha('1003') | sha('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-07     | 2019-05-07 | *      |
      | sha('1007') | sha('1007\|\|GEOFF\|\|17-214-233-1219\|\|123')   | 123       | Geoff         | 17-214-233-1219 | 2019-05-07     | 2019-05-07 | *      |
      | sha('1011') | sha('1011\|\|KAREN\|\|17-214-233-1217\|\|123')   | 123       | Karen         | 17-214-233-1217 | 2019-05-07     | 2019-05-07 | *      |

