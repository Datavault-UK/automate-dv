Feature: [SQLS-MAS-RM] Multi Active Satellites
  Loading using Period Materialization

  @fixture.multi_active_satellite
  Scenario: [SQLS-MAS-RM-01] Load data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1235 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1226 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1236 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224') | Alice         | 17-214-233-1224 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234') | Alice         | 17-214-233-1234 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1225')   | Bob           | 17-214-233-1225 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1235')   | Bob           | 17-214-233-1235 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1226')  | Chad          | 17-214-233-1226 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1236')  | Chad          | 17-214-233-1236 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1227')   | Dom           | 17-214-233-1227 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1237')   | Dom           | 17-214-233-1237 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [SQLS-MAS-RM-02] Load data into a populated multi-active satellite where all records load
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | md5('1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [SQLS-MAS-RM-03] Load data into a populated multi-active satellite where sets of records have fewer records
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1225 | md5('1002\|\|BOB\|\|17-214-233-1225')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1226 | md5('1003\|\|CHAD\|\|17-214-233-1226')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1236 | md5('1003\|\|CHAD\|\|17-214-233-1236')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1237 | md5('1004\|\|DOM\|\|17-214-233-1237')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1224 | md5('1006\|\|FRIDA\|\|17-214-233-1224') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1234 | md5('1006\|\|FRIDA\|\|17-214-233-1234') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1235 | 1993-01-02 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1225 | md5('1002\|\|BOB\|\|17-214-233-1225')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1226 | md5('1003\|\|CHAD\|\|17-214-233-1226')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1236 | md5('1003\|\|CHAD\|\|17-214-233-1236')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1237 | md5('1004\|\|DOM\|\|17-214-233-1237')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1224 | md5('1006\|\|FRIDA\|\|17-214-233-1224') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1234 | md5('1006\|\|FRIDA\|\|17-214-233-1234') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-02     | 1993-01-02 | *      |

  @fixture.multi_active_satellite
  Scenario: [SQLS-MAS-RM-04] Load data into a populated multi-active satellite where some sets of records have extra records
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1225 | md5('1002\|\|BOB\|\|17-214-233-1225')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1226 | md5('1003\|\|CHAD\|\|17-214-233-1226')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1236 | md5('1003\|\|CHAD\|\|17-214-233-1236')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1237 | md5('1004\|\|DOM\|\|17-214-233-1237')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1224 | md5('1006\|\|FRIDA\|\|17-214-233-1224') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1234 | md5('1006\|\|FRIDA\|\|17-214-233-1234') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1226 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1236 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1246 | 1993-01-02 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-02 | *      |
      | 1004        | Dom           | 17-214-233-1237 | 1993-01-02 | *      |
      | 1004        | Dom           | 17-214-233-1247 | 1993-01-02 | *      |
      | 1004        | Dom           | 17-214-233-1257 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1225 | md5('1002\|\|BOB\|\|17-214-233-1225')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1226 | md5('1003\|\|CHAD\|\|17-214-233-1226')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1236 | md5('1003\|\|CHAD\|\|17-214-233-1236')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1237 | md5('1004\|\|DOM\|\|17-214-233-1237')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1224 | md5('1006\|\|FRIDA\|\|17-214-233-1224') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1234 | md5('1006\|\|FRIDA\|\|17-214-233-1234') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1226 | md5('1003\|\|CHAD\|\|17-214-233-1226')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1236 | md5('1003\|\|CHAD\|\|17-214-233-1236')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1246 | md5('1003\|\|CHAD\|\|17-214-233-1246')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1237 | md5('1004\|\|DOM\|\|17-214-233-1237')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1247 | md5('1004\|\|DOM\|\|17-214-233-1247')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1257 | md5('1004\|\|DOM\|\|17-214-233-1257')   | 1993-01-02     | 1993-01-02 | *      |

  # CYCLE TESTS

  # todo: failing test (out of sequence)
#  @fixture.multi_active_satellite_cycle
#  Scenario: [SQLS-MAS-RM-05] Loading in cycles: waterlevel + identical data into a satellite with one value in rank column
#    Given the RAW_STAGE stage is empty
#    And the MULTI_ACTIVE_SATELLITE ma_sat is empty
#
#    # ================ LOAD 1 ===================
#    When the RAW_STAGE is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
#      | 1001        | Alice         | 17-214-233-1224 | 1993-01-02     | 1993-01-02 | *      |
#      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
#      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02     | 1993-01-02 | *      |
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
#    And I stage the STG_CUSTOMER data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
#
#    # ================ LOAD 2 ===================
#    When the RAW_STAGE is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
#      | 1001        | Alice         | 17-214-233-1224 | 1993-01-02     | 1993-01-02 | *      |
#      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
#      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02     | 1993-01-02 | *      |
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
#    And I stage the STG_CUSTOMER data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
#
#    # ================ CHECK ===================
#    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
#      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224') | Alice         | 17-214-233-1224 | 1993-01-02     | 1993-01-02 | *      |

    # todo: failing test (out of sequence)
#  @fixture.multi_active_satellite_cycle
#  Scenario: [SQLS-MAS-RM-06] Loading in cycles: waterlevel + identical data into a satellite with one value in rank column
#    Given the RAW_STAGE_TS stage is empty
#    And the MULTI_ACTIVE_SATELLITE_TS ma_sat is empty
#
#    # ================ LOAD 1 ===================
#    When the RAW_STAGE_TS is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
#      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
#    And I stage the STG_CUSTOMER_TS data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
#
#    # ================ LOAD 2 ===================
#    When the RAW_STAGE_TS is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
#      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
#    And I stage the STG_CUSTOMER_TS data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
#
#    # ================ CHECK ===================
#    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
#      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224') | Alice         | 17-214-233-1224 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
