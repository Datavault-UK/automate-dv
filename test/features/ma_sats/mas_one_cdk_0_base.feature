Feature: [MAS-1CD-B] Multi Active Satellites
  Base loads with MAS behaviour with one CDK

  ### Tests with one LDTS per PK

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-01] Load data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | Bobby         | 17-214-233-1235 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1226 | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1236 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Don           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | Dominik       | 17-214-233-1237 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214')   | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224')   | Alice         | 17-214-233-1224 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234')   | Alice         | 17-214-233-1234 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')     | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1225')     | Bob           | 17-214-233-1225 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOBBY\|\|17-214-233-1235')   | Bobby         | 17-214-233-1235 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')    | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1226')    | Chaz          | 17-214-233-1226 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1236')    | Chaz          | 17-214-233-1236 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')     | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DON\|\|17-214-233-1227')     | Don           | 17-214-233-1227 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOMINIK\|\|17-214-233-1237') | Dominik       | 17-214-233-1237 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-02] Load duplicated CDK & LTDS (with identical payload) into a non-existent multi-active satellite
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
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
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
  Scenario: [MAS-1CD-B-05] Load data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE ma_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | Bobby         | 17-214-233-1235 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1226 | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1236 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Don           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | Dominik       | 17-214-233-1237 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214')   | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224')   | Alice         | 17-214-233-1224 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234')   | Alice         | 17-214-233-1234 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')     | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1225')     | Bob           | 17-214-233-1225 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOBBY\|\|17-214-233-1235')   | Bobby         | 17-214-233-1235 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')    | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1226')    | Chaz          | 17-214-233-1226 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1236')    | Chaz          | 17-214-233-1236 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')     | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DON\|\|17-214-233-1227')     | Don           | 17-214-233-1227 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOMINIK\|\|17-214-233-1237') | Dominik       | 17-214-233-1237 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-06] Load duplicated data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE ma_sat is empty
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
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Alice         | 17-214-233-1224 | md5('1001\|\|ALICE\|\|17-214-233-1224') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Alice         | 17-214-233-1234 | md5('1001\|\|ALICE\|\|17-214-233-1234') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1225 | md5('1002\|\|BOB\|\|17-214-233-1225')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1226 | md5('1003\|\|CHAD\|\|17-214-233-1226')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1236 | md5('1003\|\|CHAD\|\|17-214-233-1236')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1237 | md5('1004\|\|DOM\|\|17-214-233-1237')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-07] Load data into an empty multi-active satellite where some records have NULL CDK(s) or Attribute(s)
    Given the MULTI_ACTIVE_SATELLITE ma_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1235 | 1993-01-01 | *      |
      | 1004        | <null>        | <null>          | 1993-01-01 | *      |
      | 1004        | Dom           | <null>          | 1993-01-01 | *      |
      | 1004        | <null>        | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-01 | *      |
      | <null>      | <null>        | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | Frida         | 17-214-233-1218 | 1993-01-01 | *      |
      | 1005        | <null>        | 17-214-233-1218 | 1993-01-01 | *      |
      | 1005        | Frida         | 17-214-233-1228 | 1993-01-01 | *      |
      | <null>      | <null>        | <null>          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Alice         | 17-214-233-1224 | md5('1001\|\|ALICE\|\|17-214-233-1224') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Alice         | 17-214-233-1234 | md5('1001\|\|ALICE\|\|17-214-233-1234') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1225 | md5('1002\|\|BOB\|\|17-214-233-1225')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | <null>        | 17-214-233-1217 | md5('1004\|\|^^\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | <null>        | 17-214-233-1218 | md5('1005\|\|^^\|\|17-214-233-1218')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Frida         | 17-214-233-1228 | md5('1005\|\|FRIDA\|\|17-214-233-1228') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-08] Load data with timestamps into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 11:14:54.396 | *      |
      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1225 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1235 | 1993-01-01 11:14:54.396 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | *      |
      | 1003        | Chad          | 17-214-233-1226 | 1993-01-01 11:14:54.396 | *      |
      | 1003        | Chad          | 17-214-233-1236 | 1993-01-01 11:14:54.396 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-01 11:14:54.396 | *      |
      | 1004        | Dom           | 17-214-233-1237 | 1993-01-01 11:14:54.396 | *      |
    And I stage the STG_CUSTOMER_TS data
    When I load the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224') | Alice         | 17-214-233-1224 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234') | Alice         | 17-214-233-1234 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1225')   | Bob           | 17-214-233-1225 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1235')   | Bob           | 17-214-233-1235 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1226')  | Chad          | 17-214-233-1226 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1236')  | Chad          | 17-214-233-1236 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1227')   | Dom           | 17-214-233-1227 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1237')   | Dom           | 17-214-233-1237 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-09] Load data into a non-existent multi-active satellite with additional columns
    Given the MULTI_ACTIVE_SATELLITE_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1234 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bobby         | 17-214-233-1235 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1226 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1236 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Don           | 17-214-233-1227 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dominik       | 17-214-233-1237 | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE_AC ma_sat
    Then the MULTI_ACTIVE_SATELLITE_AC table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_PHONE  | CUSTOMER_NAME | CUSTOMER_MT_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214')   | 17-214-233-1214 | Alice         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224')   | 17-214-233-1224 | Alice         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234')   | 17-214-233-1234 | Alice         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')     | 17-214-233-1215 | Bob           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1225')     | 17-214-233-1225 | Bob           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOBBY\|\|17-214-233-1235')   | 17-214-233-1235 | Bobby         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')    | 17-214-233-1216 | Chad          | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1226')    | 17-214-233-1226 | Chaz          | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1236')    | 17-214-233-1236 | Chaz          | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')     | 17-214-233-1217 | Dom           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DON\|\|17-214-233-1227')     | 17-214-233-1227 | Don           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOMINIK\|\|17-214-233-1237') | 17-214-233-1237 | Dominik       | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-10] Load data into an empty multi-active satellite with additional columns
    Given the MULTI_ACTIVE_SATELLITE_AC ma_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1234 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1225 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bobby         | 17-214-233-1235 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1226 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chaz          | 17-214-233-1236 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Don           | 17-214-233-1227 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dominik       | 17-214-233-1237 | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE_AC ma_sat
    Then the MULTI_ACTIVE_SATELLITE_AC table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_PHONE  | CUSTOMER_NAME | CUSTOMER_MT_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214')   | 17-214-233-1214 | Alice         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224')   | 17-214-233-1224 | Alice         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234')   | 17-214-233-1234 | Alice         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')     | 17-214-233-1215 | Bob           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1225')     | 17-214-233-1225 | Bob           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOBBY\|\|17-214-233-1235')   | 17-214-233-1235 | Bobby         | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')    | 17-214-233-1216 | Chad          | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1226')    | 17-214-233-1226 | Chaz          | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAZ\|\|17-214-233-1236')    | 17-214-233-1236 | Chaz          | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')     | 17-214-233-1217 | Dom           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DON\|\|17-214-233-1227')     | 17-214-233-1227 | Don           | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOMINIK\|\|17-214-233-1237') | 17-214-233-1237 | Dominik       | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
