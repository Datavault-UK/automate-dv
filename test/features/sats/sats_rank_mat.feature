Feature: [SAT-RM] Satellites Loaded using Rank Materialization

  @fixture.satellite
  Scenario: [SAT-RM-01] Base load of a satellite with one value in rank column loads first rank
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-02] Base load of a satellite with one value in rank column excludes NULL PKs and loads first rank,
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
      | <null>      | Emily         | 2018-04-13   | 17-214-233-1218 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-03] Incremental load of a satellite with one value in rank column loads all records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the SATELLITE sat
    And I insert by rank into the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-04] Incremental load of a satellite with one value in rank column loads all records, excluding NULL PKs
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | <null>      | Emily         | 2018-04-11   | 17-214-233-1218 | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the SATELLITE sat
    And I insert by rank into the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-05] Base load of a satellite with multiple and duplicated values in rank column loads first rank
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by LOAD_DATE and ordered by CUSTOMER_ID
    And I stage the STG_CUSTOMER data
    And I insert by rank into the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-04     | 1993-01-04 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-06] Incremental load of a satellite with multiple and duplicated values in rank column loads all records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the SATELLITE sat
    And I insert by rank into the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-04     | 1993-01-04 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-07] Base load of a satellite with one timestamp value in rank column loads all records
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.396 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.396 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 11:14:54.396 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the SATELLITE_TS sat
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-08] Incremental load of a satellite with multiple timestamps over different days in rank column loads all records
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 11:14:54.396 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 11:14:54.396 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 11:14:54.396 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the SATELLITE_TS sat
    And I insert by rank into the SATELLITE_TS sat
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-02 11:14:54.396 | 1993-01-02 11:14:54.396 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-03 11:14:54.396 | 1993-01-03 11:14:54.396 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-04 11:14:54.396 | 1993-01-04 11:14:54.396 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-09] Base load of a satellite with multiple timestamps in the same day in rank column only loads first rank
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.380 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.381 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.382 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.383 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.385 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.399 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 11:14:54.391 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 11:14:54.393 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the SATELLITE_TS sat
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.380 | 1993-01-01 11:14:54.380 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-04 11:14:54.391 | 1993-01-04 11:14:54.391 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-10] Incremental load of a satellite with multiple timestamps in the same day in rank column loads records without duplicates
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.380 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.381 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.382 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.383 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.385 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.399 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 11:14:54.391 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 11:14:54.393 | *      |
      | 1004        | Dominic       | 2018-04-13   | 17-214-233-1217 | 1993-01-04 12:14:54.393 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the SATELLITE_TS sat
    And I insert by rank into the SATELLITE_TS sat
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.380 | 1993-01-01 11:14:54.380 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')    | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-04 11:14:54.391 | 1993-01-04 11:14:54.391 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOMINIC\|\|17-214-233-1217') | Dominic       | 17-214-233-1217 | 2018-04-13   | 1993-01-04 12:14:54.393 | 1993-01-04 12:14:54.393 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-11] Incremental load of a satellite with multiple timestamps in the same day in rank column partitioned by customer id loads all records, datetimes with 3 decimal places
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 11:14:54.399 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the SATELLITE_TS sat
    And I insert by rank into the SATELLITE_TS sat
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 11:14:54.399 | 1993-01-01 11:14:54.399 | *      |

  @fixture.satellite
  Scenario: [SAT-RM-12] Incremental load of a satellite with multiple timestamps in the same day in rank column partitioned by customer id loads all records, datetimes with 6 decimal places
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME               | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.387396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.387397 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.387398 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 11:14:54.387399 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the SATELLITE_TS sat
    And I insert by rank into the SATELLITE_TS sat
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM              | LOAD_DATETIME               | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.387396 | 1993-01-01 11:14:54.387396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.387397 | 1993-01-01 11:14:54.387397 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.387398 | 1993-01-01 11:14:54.387398 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 11:14:54.387399 | 1993-01-01 11:14:54.387399 | *      |

  @not_bigquery
  @fixture.satellite
  Scenario: [SAT-RM-13] Incremental load of a satellite with multiple timestamps in the same day in rank column partitioned by customer id loads all records, datetimes with 7 decimal places
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME               | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.3847396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.3847397 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.3847398 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 11:14:54.3847399 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER_TS stage partitioned by CUSTOMER_ID and ordered by LOAD_DATETIME
    And I stage the STG_CUSTOMER_TS data
    And I insert by rank into the SATELLITE_TS sat
    And I insert by rank into the SATELLITE_TS sat
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM              | LOAD_DATETIME               | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.3847396 | 1993-01-01 11:14:54.3847396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.3847397 | 1993-01-01 11:14:54.3847397 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.3847398 | 1993-01-01 11:14:54.3847398 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 11:14:54.3847399 | 1993-01-01 11:14:54.3847399 | *      |
