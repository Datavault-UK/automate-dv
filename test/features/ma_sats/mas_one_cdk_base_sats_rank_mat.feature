Feature: [MAS-B-RM] Multi Active Satellites
  Loading using Rank Materialization

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-01] Base load of a multi-active satellite with one value in rank column loads first rank
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
    And I stage the STG_CUSTOMER data
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
  Scenario: [MAS-B-RM-02] Base load of a multi-active satellite with one value in rank column excludes NULL PKs and loads first rank,
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
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-03] Incremental load of a multi-active satellite with one value in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-04] Incremental load of a multi-active satellite with one value in rank column excluding NULL PKs, loads all records
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | <null>      | Emily         | 17-214-233-1218 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-05] Base load of a multi-active satellite with multiple and duplicated values in rank column loads first rank
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by LOAD_DATE and ordered by CUSTOMER_ID
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04     | 1993-01-04 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-06] Incremental load of a multi-active satellite with multiple and duplicated values in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04     | 1993-01-04 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-07] Base load of a multi-active satellite with one timestamp value in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-08] Incremental load of a multi-active satellite with multiple timestamps over different days in rank column loads all records
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 11:14:54.396 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-03 11:14:54.396 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.396 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-02 11:14:54.396 | 1993-01-02 11:14:54.396 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-03 11:14:54.396 | 1993-01-03 11:14:54.396 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.396 | 1993-01-04 11:14:54.396 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-09] Base load of a multi-active satellite with multiple timestamps in the same day in rank column only loads first rank
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
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.380 | 1993-01-01 11:14:54.380 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.391 | 1993-01-04 11:14:54.391 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-10] Incremental load of a multi-active satellite with multiple timestamps in the same day in rank column loads records without duplicates
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
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.393 | *      |
      | 1004        | Dominic       | 17-214-233-1217 | 1993-01-04 12:14:54.393 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                  | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214')   | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.380 | 1993-01-01 11:14:54.380 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')     | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')    | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')     | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.391 | 1993-01-04 11:14:54.391 | *      |
      #| md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')     | Dom           | 17-214-233-1217 | 1993-01-04 11:14:54.393 | 1993-01-04 11:14:54.393 | *      |
      | md5('1004') | md5('1004\|\|DOMINIC\|\|17-214-233-1217') | Dominic       | 17-214-233-1217 | 1993-01-04 12:14:54.393 | 1993-01-04 12:14:54.393 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-11] Incremental load of a multi-active satellite with multiple timestamps in the same day in rank column partitioned by customer id loads all records
    Given the MULTI_ACTIVE_SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.399 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01 11:14:54.399 | 1993-01-01 11:14:54.399 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-B-RM-12] Incremental load of a multi-active satellite with multiple sets of records per load, loads all records
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
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1227')   | Dom           | 17-214-233-1227 | 1993-01-02     | 1993-01-02 | *      |


  # CYCLE TESTS
  @fixture.multi_active_satellite_cycle
  Scenario: [MAS-B-RM-13] Loading in cycles: identical data into a multi-active satellite with one value in rank column loads first rank only and once only
    Given the RAW_STAGE stage is empty
    And the MULTI_ACTIVE_SATELLITE ma_sat is empty

    # ================ LOAD 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02     | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02     | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat

    # ================ LOAD 2 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02     | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02     | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat

    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  # todo: failing test (out of sequence)
#  @fixture.multi_active_satellite_cycle
#  Scenario: [MAS-B-RM-14] Loading in cycles: waterlevel + identical data into a multi-active satellite with one value in rank column
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
#  Scenario: [MAS-B-RM-15] Loading in cycles: waterlevel + identical data into a multi-active satellite with one value in rank column
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

  # todo: failing test (out of sequence)
#  @fixture.multi_active_satellite_cycle
#  Scenario: [MAS-B-RM-16] Loading in cycles: no CDK hashdiff + waterlevel + identical data into a multi-active satellite with one value in rank column
#    Given the RAW_STAGE stage is empty
#    And the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat is empty
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
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_NO_CDK_HASHDIFF stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
#    And I stage the STG_CUSTOMER_NO_CDK_HASHDIFF data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat
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
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_NO_CDK_HASHDIFF stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
#    And I stage the STG_CUSTOMER_NO_CDK_HASHDIFF data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF ma_sat
#
#    # ================ CHECK ===================
#    Then the MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF table should contain expected data
#      | CUSTOMER_PK | HASHDIFF             | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('1001\|\|ALICE') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1002') | md5('1002\|\|BOB')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1003') | md5('1003\|\|CHAD')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1004') | md5('1004\|\|DOM')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1001') | md5('1001\|\|ALICE') | Alice         | 17-214-233-1224 | 1993-01-02     | 1993-01-02 | *      |

  # todo: failing test (out of sequence)
#  @fixture.multi_active_satellite_cycle
#  Scenario: [MAS-B-RM-17] Loading in cycles: no PK & CDK hashdiff + waterlevel + identical data into a multi-active satellite with one value in rank column
#    Given the RAW_STAGE stage is empty
#    And the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat is empty
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
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_NO_PK_CDK_HASHDIFF stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
#    And I stage the STG_CUSTOMER_NO_PK_CDK_HASHDIFF data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat
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
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_NO_PK_CDK_HASHDIFF stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
#    And I stage the STG_CUSTOMER_NO_PK_CDK_HASHDIFF data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF ma_sat
#
#    # ================ CHECK ===================
#    Then the MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF table should contain expected data
#      | CUSTOMER_PK | HASHDIFF     | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('ALICE') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1002') | md5('BOB')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1003') | md5('CHAD')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1004') | md5('DOM')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1001') | md5('ALICE') | Alice         | 17-214-233-1224 | 1993-01-02     | 1993-01-02 | *      |

#TODO: Not working as new valid record has the same load datetime as old max datetime *
#  @fixture.multi_active_satellite_cycle
#  Scenario: [MAS-B-RM-18] Loading in cycles: waterlevel + changed payload in old record but identical to the currently valid record + partially overlapping data into a multi-active satellite with one value in rank column
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
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
#
#    # ================ LOAD 2 ===================
#    When the RAW_STAGE is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01     | 1993-01-01 | *      |
#      | 1001        | Alice         | 17-214-233-1234 | 1993-01-02     | 1993-01-02 | *      |
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
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234') | Alice         | 17-214-233-1234 | 1993-01-02     | 1993-01-02 | *      |
#
#TODO: *
#  @fixture.multi_active_satellite_cycle
#  Scenario: [MAS-B-RM-19] Loading in cycles: waterlevel + changed payload in old record but identical to the currently valid record + partially overlapping data into a multi-active satellite with one value in rank column
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
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
#
#    # ================ LOAD 2 ===================
#    When the RAW_STAGE_TS is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | 1001        | Alice         | 17-214-233-1224 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
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
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234') | Alice         | 17-214-233-1234 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |

#TODO: *These test scenarios fail to insert new "Alice" phone number 17-214-233-1234 in LOAD 2 as these load dates are not greater than max LOAD_DATE for load 1

#  @fixture.multi_active_satellite_cycle
#  Scenario: [MAS-B-RM-20] Loading in cycles: waterlevel + new payload in old record + partially overlapping data into a multi-active satellite with one value in rank column
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
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
#
#    # ================ LOAD 2 ===================
#    When the RAW_STAGE is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01     | 1993-01-01 | *      |
#      | 1001        | Alice         | 17-214-233-1234 | 1993-01-02     | 1993-01-02 | *      |
#      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
#      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
#      | 1004        | Dom           | 17-214-233-1217 | 1993-01-02     | 1993-01-02 | *      |
#    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
#    And I stage the STG_CUSTOMER data
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE ma_sat
#    # ================ CHECK ===================
#    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
#      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1224') | Alice         | 17-214-233-1224 | 1993-01-02     | 1993-01-02 | *      |
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234') | Alice         | 17-214-233-1234 | 1993-01-02     | 1993-01-02 | *      |

#  @fixture.multi_active_satellite_cycle
#  Scenario: [MAS-B-RM-21] Loading in cycles: waterlevel + new payload in old record + partially overlapping data into a multi-active satellite with one value in rank column
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
#    And I insert by rank into the MULTI_ACTIVE_SATELLITE_TS ma_sat
#
#    # ================ LOAD 2 ===================
#    When the RAW_STAGE_TS is loaded
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
#      | 1001        | Alice         | 17-214-233-1234 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
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
#      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1234') | Alice         | 17-214-233-1234 | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
