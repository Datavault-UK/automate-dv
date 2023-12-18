Feature: [SHA1] SHA1 Hashing

  @fixture.single_source_hub
  @fixture.enable_sha1
  Scenario: [HUB-04] Simple load of distinct stage data into an empty hub using SHA1 hashing
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK  | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | sha1('1001') | 1001        | 1993-01-01 | TPCH   |
      | sha1('1002') | 1002        | 1993-01-01 | TPCH   |
      | sha1('1003') | 1003        | 1993-01-01 | TPCH   |
      | sha1('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_comp_pk_hub
  @fixture.enable_sha1
  Scenario: [HUB-COMP-PK-04] Simple load of distinct stage data into an empty hub using SHA1 hashing
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_CK | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | A           | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | B           | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | A           | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | A           | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK  | CUSTOMER_CK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | sha1('1001') | A           | 1001        | 1993-01-01 | TPCH   |
      | sha1('1002') | B           | 1002        | 1993-01-01 | TPCH   |
      | sha1('1003') | A           | 1003        | 1993-01-01 | TPCH   |
      | sha1('1004') | A           | 1004        | 1993-01-01 | TPCH   |

  @fixture.multi_active_satellite_cycle
  @fixture.enable_sha1
  Scenario: [MAS-1CD-C-03] Load over several cycles
    Given the RAW_STAGE stage is empty
    And the MAS ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         | 17-214-233-1213 | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         | 17-214-233-1210 | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         | 17-214-233-1216 | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # ================ DAY 3 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 17-214-233-1213 | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 17-214-233-1218 | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 17-214-233-1216 | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # ================ DAY 4 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 17-214-233-1217 | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # =============== CHECKS ===================
    Then the MAS table should contain expected data
      | CUSTOMER_PK  | HASHDIFF                                   | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1001') | sha1('1001\|\|ALBERT\|\|17-214-233-1211')  | Albert        | 17-214-233-1211 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1214')   | Jenny         | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1012') | sha1('1012\|\|ALBERT\|\|17-214-233-1215')  | Albert        | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1003') | sha1('1003\|\|CHRIS\|\|17-214-233-1213')   | Chris         | 17-214-233-1213 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1004') | sha1('1004\|\|DAVID\|\|17-214-233-1210')   | David         | 17-214-233-1210 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1216')   | Jenny         | 17-214-233-1216 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1003') | sha1('1003\|\|CLAIRE\|\|17-214-233-1213')  | Claire        | 17-214-233-1213 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1005') | sha1('1005\|\|ELWYN\|\|17-214-233-1218')   | Elwyn         | 17-214-233-1218 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1006') | sha1('1006\|\|FREIA\|\|17-214-233-1216')   | Freia         | 17-214-233-1216 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1007') | sha1('1007\|\|GEOFF\|\|17-214-233-1219')   | Geoff         | 17-214-233-1219 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1011') | sha1('1011\|\|KAREN\|\|17-214-233-1217')   | Karen         | 17-214-233-1217 | 2019-05-07     | 2019-05-07 | *      |

  @fixture.multi_active_satellite_cycle
  @fixture.enable_sha1
  Scenario: [MAS-1CD-C-08] Load over several cycles
    Given the RAW_STAGE stage is empty
    And the MAS ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | 1001        | Albert        | 17-214-233-1221 | 2019-01-01     | 2019-01-01 | *      |
      | 1001        | Albert        | 17-214-233-1231 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | 1002        | Beth          | 17-214-233-1232 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | 1003        | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | 1010        | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | 1012        | Albert        | 17-214-233-1215 | 2019-01-01     | 2019-01-01 | *      |
      | 1012        | Albert        | 17-214-233-1225 | 2019-01-01     | 2019-01-01 | *      |
      | 1012        | Albert        | 17-214-233-1235 | 2019-01-01     | 2019-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # ================ DAY 2 ===================
    # Beah (hd-), Chris (hd-), David (new), Jenny (+)
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 2019-01-02     | 2019-01-02 | *      |
      | 1002        | Beah          | 17-214-233-1222 | 2019-01-02     | 2019-01-02 | *      |
      | 1003        | Chris         | 17-214-233-1223 | 2019-01-02     | 2019-01-02 | *      |
      | 1004        | David         | 17-214-233-1216 | 2019-01-02     | 2019-01-02 | *      |
      | 1004        | David         | 17-214-233-1226 | 2019-01-02     | 2019-01-02 | *      |
      | 1004        | David         | 17-214-233-1236 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1212 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1222 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1232 | 2019-01-02     | 2019-01-02 | *      |
      | 1010        | Jenny         | 17-214-233-1242 | 2019-01-02     | 2019-01-02 | *      |
      | 1012        | Albert        | 17-214-233-1215 | 2019-01-02     | 2019-01-02 | *      |
      | 1012        | Albert        | 17-214-233-1225 | 2019-01-02     | 2019-01-02 | *      |
      | 1012        | Albert        | 17-214-233-1235 | 2019-01-02     | 2019-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # ================ DAY 3 ===================
    # Beth (hd+), David (-), Freia (new, dupl)
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1222 | 2019-01-03     | 2019-01-03 | *      |
      | 1002        | Beth          | 17-214-233-1232 | 2019-01-03     | 2019-01-03 | *      |
      | 1003        | Chris         | 17-214-233-1223 | 2019-01-03     | 2019-01-03 | *      |
      | 1004        | David         | 17-214-233-1216 | 2019-01-03     | 2019-01-03 | *      |
      | 1004        | David         | 17-214-233-1226 | 2019-01-03     | 2019-01-03 | *      |
      | 1006        | Freia         | 17-214-233-1212 | 2019-01-03     | 2019-01-03 | *      |
      | 1006        | Freia         | 17-214-233-1212 | 2019-01-03     | 2019-01-03 | *      |

    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # ================ DAY 4 ===================
    # Beah (hd), Charley (hd), Geoff (new, dupl), Jenny (hd),
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beah          | 17-214-233-1222 | 2019-01-04     | 2019-01-04 | *      |
      | 1002        | Beah          | 17-214-233-1232 | 2019-01-04     | 2019-01-04 | *      |
      | 1003        | Charley       | 17-214-233-1223 | 2019-01-04     | 2019-01-04 | *      |
      | 1004        | David         | 17-214-233-1216 | 2019-01-04     | 2019-01-04 | *      |
      | 1004        | David         | 17-214-233-1226 | 2019-01-04     | 2019-01-04 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 2019-01-04     | 2019-01-04 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 2019-01-04     | 2019-01-04 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenny         | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenny         | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenny         | 17-214-233-1332 | 2019-01-04     | 2019-01-04 | *      |
      | 1010        | Jenny         | 17-214-233-1342 | 2019-01-04     | 2019-01-04 | *      |

    And I stage the STG_CUSTOMER data
    And I load the MAS ma_sat

    # =============== CHECKS ===================
    Then the MAS table should contain expected data
      | CUSTOMER_PK  | HASHDIFF                                   | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1001') | sha1('1001\|\|ALBERT\|\|17-214-233-1211')  | Albert        | 17-214-233-1211 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1001') | sha1('1001\|\|ALBERT\|\|17-214-233-1221')  | Albert        | 17-214-233-1221 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1001') | sha1('1001\|\|ALBERT\|\|17-214-233-1231')  | Albert        | 17-214-233-1231 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1212')    | Beth          | 17-214-233-1212 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1222')    | Beth          | 17-214-233-1222 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1232')    | Beth          | 17-214-233-1232 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1213') | Charley       | 17-214-233-1213 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1223') | Charley       | 17-214-233-1223 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1233') | Charley       | 17-214-233-1233 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1214')   | Jenny         | 17-214-233-1214 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1224')   | Jenny         | 17-214-233-1224 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1234')   | Jenny         | 17-214-233-1234 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1012') | sha1('1012\|\|ALBERT\|\|17-214-233-1215')  | Albert        | 17-214-233-1215 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1012') | sha1('1012\|\|ALBERT\|\|17-214-233-1225')  | Albert        | 17-214-233-1225 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1012') | sha1('1012\|\|ALBERT\|\|17-214-233-1235')  | Albert        | 17-214-233-1235 | 2019-01-01     | 2019-01-01 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1222')    | Beah          | 17-214-233-1222 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1003') | sha1('1003\|\|CHRIS\|\|17-214-233-1223')   | Chris         | 17-214-233-1223 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1004') | sha1('1004\|\|DAVID\|\|17-214-233-1216')   | David         | 17-214-233-1216 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1004') | sha1('1004\|\|DAVID\|\|17-214-233-1226')   | David         | 17-214-233-1226 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1004') | sha1('1004\|\|DAVID\|\|17-214-233-1236')   | David         | 17-214-233-1236 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1212')   | Jenny         | 17-214-233-1212 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1222')   | Jenny         | 17-214-233-1222 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1232')   | Jenny         | 17-214-233-1232 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1242')   | Jenny         | 17-214-233-1242 | 2019-01-02     | 2019-01-02 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1312')    | Beth          | 17-214-233-1312 | 2019-01-03     | 2019-01-03 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1222')    | Beth          | 17-214-233-1222 | 2019-01-03     | 2019-01-03 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1232')    | Beth          | 17-214-233-1232 | 2019-01-03     | 2019-01-03 | *      |
      | sha1('1004') | sha1('1004\|\|DAVID\|\|17-214-233-1216')   | David         | 17-214-233-1216 | 2019-01-03     | 2019-01-03 | *      |
      | sha1('1004') | sha1('1004\|\|DAVID\|\|17-214-233-1226')   | David         | 17-214-233-1226 | 2019-01-03     | 2019-01-03 | *      |
      | sha1('1006') | sha1('1006\|\|FREIA\|\|17-214-233-1212')   | Freia         | 17-214-233-1212 | 2019-01-03     | 2019-01-03 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1212')    | Beah          | 17-214-233-1212 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1222')    | Beah          | 17-214-233-1222 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1232')    | Beah          | 17-214-233-1232 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1223') | Charley       | 17-214-233-1223 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1007') | sha1('1007\|\|GEOFF\|\|17-214-233-1219')   | Geoff         | 17-214-233-1219 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1312')   | Jenny         | 17-214-233-1312 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1322')   | Jenny         | 17-214-233-1322 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1332')   | Jenny         | 17-214-233-1332 | 2019-01-04     | 2019-01-04 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1342')   | Jenny         | 17-214-233-1342 | 2019-01-04     | 2019-01-04 | *      |


  @fixture.multi_active_satellite_cycle
  @fixture.enable_sha1
  Scenario: [MAS-2CD-BSC-04] Load over several cycles
    Given the RAW_STAGE_TWO_CDK stage is empty
    And the MAS_TWO_CDK ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 17-214-233-1211 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 17-214-233-1214 | 123       | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 17-214-233-1215 | 123       | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MAS_TWO_CDK ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 17-214-233-1212 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         | 17-214-233-1213 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         | 17-214-233-1210 | 123       | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         | 17-214-233-1216 | 123       | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MAS_TWO_CDK ma_sat

    # ================ DAY 3 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 17-214-233-1213 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 17-214-233-1218 | 123       | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 17-214-233-1216 | 123       | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MAS_TWO_CDK ma_sat

    # ================ DAY 4 ===================
    When the RAW_STAGE_TWO_CDK is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 17-214-233-1212 | 124       | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 17-214-233-1213 | 123       | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 17-214-233-1219 | 123       | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 17-214-233-1217 | 123       | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    And I load the MAS_TWO_CDK ma_sat

    # =============== CHECKS ===================
    Then the MAS_TWO_CDK table should contain expected data
      | CUSTOMER_PK  | HASHDIFF                                          | EXTENSION | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1001') | sha1('1001\|\|ALBERT\|\|17-214-233-1211\|\|123')  | 123       | Albert        | 17-214-233-1211 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1214\|\|123')   | 123       | Jenny         | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1012') | sha1('1012\|\|ALBERT\|\|17-214-233-1215\|\|123')  | 123       | Albert        | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1002') | sha1('1002\|\|BEAH\|\|17-214-233-1212\|\|123')    | 123       | Beah          | 17-214-233-1212 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1003') | sha1('1003\|\|CHRIS\|\|17-214-233-1213\|\|123')   | 123       | Chris         | 17-214-233-1213 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1004') | sha1('1004\|\|DAVID\|\|17-214-233-1210\|\|123')   | 123       | David         | 17-214-233-1210 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1010') | sha1('1010\|\|JENNY\|\|17-214-233-1216\|\|123')   | 123       | Jenny         | 17-214-233-1216 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1212\|\|123')    | 123       | Beth          | 17-214-233-1212 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1003') | sha1('1003\|\|CLAIRE\|\|17-214-233-1213\|\|123')  | 123       | Claire        | 17-214-233-1213 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1005') | sha1('1005\|\|ELWYN\|\|17-214-233-1218\|\|123')   | 123       | Elwyn         | 17-214-233-1218 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1006') | sha1('1006\|\|FREIA\|\|17-214-233-1216\|\|123')   | 123       | Freia         | 17-214-233-1216 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1002') | sha1('1002\|\|BETH\|\|17-214-233-1212\|\|124')    | 124       | Beth          | 17-214-233-1212 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1003') | sha1('1003\|\|CHARLEY\|\|17-214-233-1213\|\|123') | 123       | Charley       | 17-214-233-1213 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1007') | sha1('1007\|\|GEOFF\|\|17-214-233-1219\|\|123')   | 123       | Geoff         | 17-214-233-1219 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1011') | sha1('1011\|\|KAREN\|\|17-214-233-1217\|\|123')   | 123       | Karen         | 17-214-233-1217 | 2019-05-07     | 2019-05-07 | *      |

  @fixture.satellite_cycle
  @fixture.enable_sha1
  Scenario: [SAT-CYC-07] SATELLITE load over several cycles with SHA1 hashing
    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is empty

    # ================ DAY 1 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | 1991-03-21   | Jenny         | 17-214-233-1223 | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | 1990-02-03   | Albert        | 17-214-233-1225 | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 2 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | 1995-08-07   | Beah          | 17-214-233-1215 | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | 1990-02-03   | Chris         | 17-214-233-1216 | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | 1992-01-30   | David         | 17-214-233-1217 | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | 1991-03-25   | Jenny         | 17-214-233-1223 | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 3 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | 1990-02-03   | Claire        | 17-214-233-1216 | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | 2001-07-23   | Elwyn         | 17-214-233-1218 | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | 1960-01-01   | Freia         | 17-214-233-1219 | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 4 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | 1995-08-07   | Beah          | 17-214-233-1215 | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | 1990-02-03   | Geoff         | 17-214-233-1220 | 2019-05-07     | 2019-05-07 | *      |
      | 1010        | 1991-03-25   | Jenny         | 17-214-233-1223 | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | 1978-06-16   | Karen         | 17-214-233-1224 | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # =============== CHECKS ===================
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK  | HASHDIFF                                                 | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1001') | sha1('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1002') | sha1('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1002') | sha1('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1215')    | 1995-08-07   | Beah          | 17-214-233-1215 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1002') | sha1('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1002') | sha1('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1215')    | 1995-08-07   | Beah          | 17-214-233-1215 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1003') | sha1('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1003') | sha1('1990-02-03\|\|1003\|\|CHRIS\|\|17-214-233-1216')   | 1990-02-03   | Chris         | 17-214-233-1216 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1003') | sha1('1990-02-03\|\|1003\|\|CLAIRE\|\|17-214-233-1216')  | 1990-02-03   | Claire        | 17-214-233-1216 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1003') | sha1('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1004') | sha1('1992-01-30\|\|1004\|\|DAVID\|\|17-214-233-1217')   | 1992-01-30   | David         | 17-214-233-1217 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1005') | sha1('2001-07-23\|\|1005\|\|ELWYN\|\|17-214-233-1218')   | 2001-07-23   | Elwyn         | 17-214-233-1218 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1006') | sha1('1960-01-01\|\|1006\|\|FREIA\|\|17-214-233-1219')   | 1960-01-01   | Freia         | 17-214-233-1219 | 2019-05-06     | 2019-05-06 | *      |
      | sha1('1007') | sha1('1990-02-03\|\|1007\|\|GEOFF\|\|17-214-233-1220')   | 1990-02-03   | Geoff         | 17-214-233-1220 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1010') | sha1('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1223')   | 1991-03-21   | Jenny         | 17-214-233-1223 | 2019-05-04     | 2019-05-04 | *      |
      | sha1('1010') | sha1('1991-03-25\|\|1010\|\|JENNY\|\|17-214-233-1223')   | 1991-03-25   | Jenny         | 17-214-233-1223 | 2019-05-05     | 2019-05-05 | *      |
      | sha1('1011') | sha1('1978-06-16\|\|1011\|\|KAREN\|\|17-214-233-1224')   | 1978-06-16   | Karen         | 17-214-233-1224 | 2019-05-07     | 2019-05-07 | *      |
      | sha1('1012') | sha1('1990-02-03\|\|1012\|\|ALBERT\|\|17-214-233-1225')  | 1990-02-03   | Albert        | 17-214-233-1225 | 2019-05-04     | 2019-05-04 | *      |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-07] Load data and ghost record into non-existent satellite with SHA1 hash
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-08] Load data and ghost record into an empty satellite with SHA1 hash
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-09] Load data and ghost record into satellite already populated with a ghost record with SHA1 hash
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1006')                             | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1005')                             | Eric          | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1006')                             | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-10] Load data and ghost record into already populated satellite with SHA1 hash
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK  | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1006') | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1005')                             | Eric          | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1006')                             | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-11] Load data into a non-existent satellite with ghost records not enabled with SHA1 hash
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK  | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1001') | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1002') | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1003') | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1004') | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @postgres
  @fixture.hashing
  @fixture.enable_sha1
  Scenario: [HASH-03] Check hash value length for SHA1 hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using test hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 20                |
      | snowflake_hash  | 20                |
      | databricks_hash | 20                |
      | bigquery_hash   | 20                |
      | sqlserver_hash  | 20                |

  @postgres
  @fixture.hashing
  @fixture.enable_sha1
  Scenario: [HASH-06] Check hash value length for SHA1 hashing in postgres
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 20                |
      | snowflake_hash  | 20                |
      | databricks_hash | 20                |
      | bigquery_hash   | 20                |
      | sqlserver_hash  | 20                |

  @postgres
  @fixture.hashing
  @fixture.enable_sha1
  @fixture.disable_hashing_upper_case
  Scenario: [HASH-09] Check hash value length for SHA1 hashing in postgres with upper casing disabled
    Given there is data available
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    And using dbtvault hash calculation on table
      | VALUE_STRING    |
      | postgres_hash   |
      | snowflake_hash  |
      | databricks_hash |
      | bigquery_hash   |
      | sqlserver_hash  |
    Then the SAMPLE_DATA table should contain the following data
      | value_string    | hash_value_length |
      | postgres_hash   | 20                |
      | snowflake_hash  | 20                |
      | databricks_hash | 20                |
      | bigquery_hash   | 20                |
      | sqlserver_hash  | 20                |

  @fixture.staging_null_columns
  @fixture.enable_sha1
  Scenario: [STG-42] Staging with null columns configuration where there is a required and optional key, using SHA256 hash algorithm
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | <null>        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | <null>      | <null>        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL      |
      | CUSTOMER_ID | CUSTOMER_NAME |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK  | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE    | HASHDIFF                                     |
      | sha1('1001') | 1001                 | 1001        | <null>                 | -2            | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('1997-04-24\|\|-2\|\|17-214-233-1214')  |
      | sha1('1002') | 1002                 | 1002        | Bob                    | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('2006-04-17\|\|BOB\|\|17-214-233-1215') |
      | sha1('-1')   | <null>               | -1          | <null>                 | -2            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('2013-02-04\|\|-2\|\|17-214-233-1216')  |
      | sha1('-1')   | <null>               | -1          | Dom                    | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('2018-04-13\|\|DOM\|\|17-214-233-1217') |

  @fixture.staging_null_columns
  @fixture.enable_sha1
  Scenario: [STG-44] Staging with null columns configuration where there is a required and optional key, using SHA1 hash algorithm and custom null key values
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | -1          | <null>        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | -2          | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | <null>      | <null>        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have null columns in the STG_CUSTOMER model and null_key_required is -6 and null_key_optional is -9
      | REQUIRED    | OPTIONAL      |
      | CUSTOMER_ID | CUSTOMER_NAME |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE    | HASHDIFF                                     |
      | sha1('-1')  | -1                   | -1          | <null>                 | -9            | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('1997-04-24\|\|-9\|\|17-214-233-1214')  |
      | sha1('-2')  | -2                   | -2          | Bob                    | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('2006-04-17\|\|BOB\|\|17-214-233-1215') |
      | sha1('-6')  | <null>               | -6          | <null>                 | -9            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('2013-02-04\|\|-9\|\|17-214-233-1216')  |
      | sha1('-6')  | <null>               | -6          | Dom                    | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | RAW_STAGE | sha1('2018-04-13\|\|DOM\|\|17-214-233-1217') |

  @fixture.staging
  @fixture.enable_sha1
  Scenario: [STG-46] Staging with derived, hashed, ranked and source columns, using SHA1 hash algorithm, single hashdiff column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                  |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME             | PARTITION_BY | ORDER_BY  |
      | AUTOMATE_DV_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK  | HASHDIFF      | EFFECTIVE_FROM | SOURCE    | AUTOMATE_DV_RANK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | sha1('1001') | sha1('ALICE') | 1993-01-01     | RAW_STAGE | 1                |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | sha1('1002') | sha1('BOB')   | 1993-01-01     | RAW_STAGE | 1                |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | sha1('1003') | sha1('CHAD')  | 1993-01-01     | RAW_STAGE | 1                |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | sha1('1004') | sha1('DOM')   | 1993-01-01     | RAW_STAGE | 1                |

  @fixture.staging
  @fixture.enable_sha1
  Scenario: [STG-48] Staging with derived, hashed, ranked and source columns, using SHA1 hash algorithm, multiple PK column, single hashdiff column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK                 | HASHDIFF                  |
      | [CUSTOMER_ID,CUSTOMER_NAME] | hashdiff('CUSTOMER_NAME') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME             | PARTITION_BY | ORDER_BY  |
      | AUTOMATE_DV_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK           | HASHDIFF      | EFFECTIVE_FROM | SOURCE    | AUTOMATE_DV_RANK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | sha1('1001\|\|ALICE') | sha1('ALICE') | 1993-01-01     | RAW_STAGE | 1                |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | sha1('1002\|\|BOB')   | sha1('BOB')   | 1993-01-01     | RAW_STAGE | 1                |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | sha1('1003\|\|CHAD')  | sha1('CHAD')  | 1993-01-01     | RAW_STAGE | 1                |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | sha1('1004\|\|DOM')   | sha1('DOM')   | 1993-01-01     | RAW_STAGE | 1                |

