Feature: Multi Active Satellites - Loading in cycles using separate manual loads of base satellites behaviour with one CDK

  @fixture.multi_active_satellite_cycle
  Scenario: [SAT-CYCLE] MULTI_ACTIVE_SATELLITE load over several cycles
    Given the RAW_STAGE stage is empty
    And the MULTI_ACTIVE_SATELLITE ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211   | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 17-214-233-1212   | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 17-214-233-1213   | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 17-214-233-1214   | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 17-214-233-1215   | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME |  CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          |  17-214-233-1212   | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         |  17-214-233-1213   | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         |  17-214-233-1210   | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         |  17-214-233-1216   | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 3 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212   | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 17-214-233-1213   | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 17-214-233-1218   | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 17-214-233-1216   | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 4 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212  | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 17-214-233-1213  | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 17-214-233-1219  | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 17-214-233-1217  | 2019-05-07     | 2019-05-07 | *      |
      | 1010        | Jenny         | 17-214-233-1218  | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_NAME | CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALBERT\|\|17-214-233-1211')  | Albert        | 17-214-233-1211   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1214')   | Jenny         | 17-214-233-1214   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1012') | md5('1012\|\|ALBERT\|\|17-214-233-1215')  | Albert        | 17-214-233-1215   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1003') | md5('1003\|\|CHRIS\|\|17-214-233-1213')   | Chris         | 17-214-233-1213   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1004') | md5('1004\|\|DAVID\|\|17-214-233-1210')   | David         | 17-214-233-1210   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1216')   | Jenny         | 17-214-233-1216   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1003') | md5('1003\|\|CLAIRE\|\|17-214-233-1213')  | Claire        | 17-214-233-1213   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1005') | md5('1005\|\|ELWYN\|\|17-214-233-1218')   | Elwyn         | 17-214-233-1218   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1006') | md5('1006\|\|FREIA\|\|17-214-233-1216')   | Freia         | 17-214-233-1216   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1002') | md5('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1007') | md5('1007\|\|GEOFF\|\|17-214-233-1219')   | Geoff         | 17-214-233-1219   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1011') | md5('1011\|\|KAREN\|\|17-214-233-1217')   | Karen         | 17-214-233-1217   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|17-214-233-1218')   | Jenny         | 17-214-233-1218   | 2019-05-07     | 2019-05-07 | *      |

  @fixture.multi_active_satellite_cycle
  @fixture.sha
  Scenario: [SAT-CYCLE-SHA] MULTI_ACTIVE_SATELLITE load over several cycles
    Given the RAW_STAGE stage is empty
    And the MULTI_ACTIVE_SATELLITE ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211   | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 17-214-233-1212   | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 17-214-233-1213   | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 17-214-233-1214   | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 17-214-233-1215   | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME |  CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          |  17-214-233-1212   | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         |  17-214-233-1213   | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         |  17-214-233-1210   | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         |  17-214-233-1216   | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 3 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212   | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 17-214-233-1213   | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 17-214-233-1218   | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 17-214-233-1216   | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 4 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212  | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 17-214-233-1213  | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 17-214-233-1219  | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 17-214-233-1217  | 2019-05-07     | 2019-05-07 | *      |
#      | 1010        | Jenny         | 17-214-233-1216  | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MULTI_ACTIVE_SATELLITE ma_sat

    # =============== CHECKS ===================
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_NAME | CUSTOMER_PHONE    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha('1001') | sha('1001\|\|ALBERT\|\|17-214-233-1211')  | Albert        | 17-214-233-1211   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1002') | sha('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1003') | sha('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1010') | sha('1010\|\|JENNY\|\|17-214-233-1214')   | Jenny         | 17-214-233-1214   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1012') | sha('1012\|\|ALBERT\|\|17-214-233-1215')  | Albert        | 17-214-233-1215   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1002') | sha('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1003') | sha('1003\|\|CHRIS\|\|17-214-233-1213')   | Chris         | 17-214-233-1213   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1004') | sha('1004\|\|DAVID\|\|17-214-233-1210')   | David         | 17-214-233-1210   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1010') | sha('1010\|\|JENNY\|\|17-214-233-1216')   | Jenny         | 17-214-233-1216   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1002') | sha('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1003') | sha('1003\|\|CLAIRE\|\|17-214-233-1213')  | Claire        | 17-214-233-1213   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1005') | sha('1005\|\|ELWYN\|\|17-214-233-1218')   | Elwyn         | 17-214-233-1218   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1006') | sha('1006\|\|FREIA\|\|17-214-233-1216')   | Freia         | 17-214-233-1216   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1002') | sha('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212   | 2019-05-07     | 2019-05-07 | *      |
      | sha('1003') | sha('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213   | 2019-05-07     | 2019-05-07 | *      |
      | sha('1007') | sha('1007\|\|GEOFF\|\|17-214-233-1219')   | Geoff         | 17-214-233-1219   | 2019-05-07     | 2019-05-07 | *      |
      | sha('1011') | sha('1011\|\|KAREN\|\|17-214-233-1217')   | Karen         | 17-214-233-1217   | 2019-05-07     | 2019-05-07 | *      |
