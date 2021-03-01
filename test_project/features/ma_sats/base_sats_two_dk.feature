@fixture.set_workdir
Feature: Multi Active Satellites

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD] Load data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_DK table does not exist
    And the RAW_STAGE_TWO_DK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_TWO_DK stage
    When I load the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_DK table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                       | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | Alice         | 17-214-233-1214 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | Bob           | 17-214-233-1215 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | Chad          | 17-214-233-1216 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | Dom           | 17-214-233-1217 | 123       | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD] Load duplicated data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_DK table does not exist
    And the RAW_STAGE_TWO_DK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_TWO_DK stage
    When I load the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_DK table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                       | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | Alice         | 17-214-233-1214 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | Bob           | 17-214-233-1215 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | Chad          | 17-214-233-1216 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | Dom           | 17-214-233-1217 | 123       | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD-EMPTY] Load data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat is empty
    And the RAW_STAGE_TWO_DK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_TWO_DK stage
    When I load the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_DK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD-EMPTY] Load duplicated data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat is empty
    And the RAW_STAGE_TWO_DK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_TWO_DK stage
    When I load the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_DK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated multi-active satellite where all records load
    Given the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE_TWO_DK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 123       | 1993-01-02 | *      |
    And I create the STG_CUSTOMER_TWO_DK stage
    When I load the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_DK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 123       | md5('1005\|\|ERIC\|\|17-214-233-1217\|\|123')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated multi-active satellite where some records overlap
    Given the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|17-214-233-1215\|\|BOB\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|17-214-233-1216\|\|CHAD\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|17-214-233-1217\|\|DOM\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 123       | md5('1006\|\|17-214-233-1217\|\|FRIDA\|\|123') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE_TWO_DK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 123       | 1993-01-02 | *      |
    And I create the STG_CUSTOMER_TWO_DK stage
    When I load the MULTI_ACTIVE_SATELLITE_TWO_DK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_DK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|17-214-233-1214\|\|ALICE\|\|123') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|17-214-233-1215\|\|BOB\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|17-214-233-1216\|\|CHAD\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|17-214-233-1217\|\|DOM\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 123       | md5('1005\|\|17-214-233-1217\|\|ERIC\|\|123')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 123       | md5('1006\|\|17-214-233-1217\|\|FRIDA\|\|123') | 1993-01-01     | 1993-01-01 | *      |