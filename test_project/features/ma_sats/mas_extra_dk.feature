@fixture.set_workdir
Feature: Multi Active Satellites

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD] Load data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123        | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 124        | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 123        | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 133        | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 134        | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 135        | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123        | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123        | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123        | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123        | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123        | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123        | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the MULTI_ACTIVE_SATELLITE msat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD] Load duplicated data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the MULTI_ACTIVE_SATELLITE msat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD-EMPTY] Load data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE msat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the MULTI_ACTIVE_SATELLITE msat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [BASE-LOAD-EMPTY] Load duplicated data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE msat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the MULTI_ACTIVE_SATELLITE msat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated multi-active satellite where all records load
    Given the MULTI_ACTIVE_SATELLITE msat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    When I load the MULTI_ACTIVE_SATELLITE msat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated multi-active satellite where some records overlap
    Given the MULTI_ACTIVE_SATELLITE msat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    When I load the MULTI_ACTIVE_SATELLITE msat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |