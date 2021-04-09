@fixture.set_workdir
Feature: Multi Active Satellites - Loading using Rank Materialization

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-BASE] Base load of a satellite with one value in rank column loads first rank
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1227')   | Dom           | 17-214-233-1227 | 1993-01-02     | 1993-01-02 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-BASE] Base load of a satellite with one value in rank column excludes NULL PKs and loads first rank,
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02 | *      |
      | <null>      | Emily         | 17-214-233-1218 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-INC] Incremental load of a satellite with one value in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-INC] Incremental load of a satellite with one value in rank column loads all records, excluding NULL PKs
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | <null>      | Emily         | 17-214-233-1218 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-BASE] Base load of a satellite with multiple and duplicated values in rank column loads first rank
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by LOAD_DATE and ordered by CUSTOMER_ID
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04     | 1993-01-04 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-INC] Incremental load of a satellite with multiple and duplicated values in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04     | 1993-01-04 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-BASE] Base load of a satellite with one timestamp value in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I create the STG_CUSTOMER_TS stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-INC] Incremental load of a satellite with multiple timestamps over different days in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 11:14:54.396 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-03 11:14:54.396 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.396 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I create the STG_CUSTOMER_TS stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-02 11:14:54.396 | 1993-01-02 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-03 11:14:54.396 | 1993-01-03 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.396 | 1993-01-04 11:14:54.396 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-BASE] Base load of a satellite with multiple timestamps in the same day in rank column only loads first rank
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.380 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.381 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.382 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.383 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.385 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.399 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.391 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.393 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I create the STG_CUSTOMER_TS stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.380 | 1993-01-01 11:14:54.380 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.391 | 1993-01-04 11:14:54.391 | *      |

  # todo: when insertion by rank the 2nd time it inserts all 1004 records, not just Dominic
  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-INC] Incremental load of a satellite with multiple timestamps in the same day in rank column loads records without duplicates
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.380 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.381 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.382 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.383 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.385 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.399 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.391 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.393 | *      |
      | 1004        | Dominic       | 17-214-233-1217 | 1993-01-04 12:14:54.393 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I create the STG_CUSTOMER_TS stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    #And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214')   | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.380 | 1993-01-01 11:14:54.380 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')     | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')    | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')     | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.391 | 1993-01-04 11:14:54.391 | *      |
      | md5('1004') | md5('1004\|\|DOMINIC\|\|17-214-233-1217') | Dominic       | 17-214-233-1217 | 1993-01-04 12:14:54.393 | 1993-01-04 12:14:54.393 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-INC] Incremental load of a satellite with multiple timestamps in the same day in rank column partitioned by customer id loads all records
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.399 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I create the STG_CUSTOMER_TS stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.399 | 1993-01-01 11:14:54.399 | *      |

  # todo: when it does the incremental loading (due to line 258), it pulls both Doms again rather than just the last one
  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-INC] Incremental load of a satellite with one value in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1227 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1227')   | Dom           | 17-214-233-1227 | 1993-01-02     | 1993-01-02 | *      |

  @fixture.multi_active_satellite_cycle
  Scenario: [SAT-RANK-MAT-BASE-CYCLE] Loading in cycles: identical data into a satellite with one value in rank column loads first rank only and once only
#    Given the MULTI_ACTIVE_SATELLITE ma_sat is empty
    Given the RAW_STAGE stage is empty
    And the MULTI_ACTIVE_SATELLITE ma_sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02     | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02     | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ DAY 2 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02     | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02     | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat

    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [SAT-RANK-MAT-BASE-CYCLE] Subsequent loads of overlapping data into a satellite with one value in rank column
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1224 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224') | Alice         | 17-214-233-1224 | 1993-01-02     | 1993-01-02 | *      |
