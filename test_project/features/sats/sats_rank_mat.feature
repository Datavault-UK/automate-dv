@fixture.set_workdir
Feature: Satellites Loaded using Rank Materialization

  @fixture.satellite
  Scenario: [SAT-RANK-MAT] Base load of a satellite with one value in rank column loads all records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_WITH_RANK stage
    And I insert by rank into the SATELLITE sat with a DBTVAULT_RANK rank column
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-RANK-MAT] Base load of a satellite with multiple values in rank column only loads first rank
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 | *      |
    And I create the STG_CUSTOMER_WITH_RANK stage
    And I insert by rank into the SATELLITE sat with a DBTVAULT_RANK rank column
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-RANK-MAT] Iterative load of a satellite with multiple values in rank column loads all records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 | *      |
    And I create the STG_CUSTOMER_WITH_RANK stage
    And I insert by rank into the SATELLITE sat with a DBTVAULT_RANK rank column
    And I insert by rank into the SATELLITE sat with a DBTVAULT_RANK rank column
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-04     | 1993-01-04 | *      |

  @fixture.satellite
  Scenario: [SAT-RANK-MAT] Base load of a satellite with one timestamp value in rank column loads all records
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.396 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.396 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 11:14:54.396 | *      |
    And I create the STG_CUSTOMER_WITH_RANK_TS stage
    And I insert by rank into the SATELLITE_TS sat with a DBTVAULT_RANK rank column
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |

  @fixture.satellite
  Scenario: [SAT-RANK-MAT] Iterative load of a satellite with multiple timestamps over different days in rank column loads all records
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 11:14:54.396 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 11:14:54.396 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-04 11:14:54.396 | *      |
    And I create the STG_CUSTOMER_WITH_RANK_TS stage
    And I insert by rank into the SATELLITE_TS sat with a DBTVAULT_RANK rank column
    And I insert by rank into the SATELLITE_TS sat with a DBTVAULT_RANK rank column
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-02 11:14:54.396 | 1993-01-02 11:14:54.396 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-03 11:14:54.396 | 1993-01-03 11:14:54.396 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-04 11:14:54.396 | 1993-01-04 11:14:54.396 | *      |

  @fixture.satellite
  Scenario: [SAT-RANK-MAT] Base load of a satellite with multiple timestamps in the same day in rank column only loads first rank
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 11:14:54.399 | *      |
    And I create the STG_CUSTOMER_WITH_RANK_TS stage
    And I insert by rank into the SATELLITE_TS sat with a DBTVAULT_RANK rank column
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |

  @fixture.satellite
  Scenario: [SAT-RANK-MAT] Base load of a satellite with multiple timestamps in the same day in rank column loads all records
    Given the SATELLITE_TS table does not exist
    And the RAW_STAGE_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 11:14:54.396 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 11:14:54.397 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 11:14:54.398 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 11:14:54.399 | *      |
    And I create the STG_CUSTOMER_WITH_RANK_TS stage
    And I insert by rank into the SATELLITE_TS sat with a DBTVAULT_RANK rank column
    And I insert by rank into the SATELLITE_TS sat with a DBTVAULT_RANK rank column
    Then the SATELLITE_TS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 11:14:54.396 | 1993-01-01 11:14:54.396 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 11:14:54.397 | 1993-01-01 11:14:54.397 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 11:14:54.398 | 1993-01-01 11:14:54.398 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 11:14:54.399 | 1993-01-01 11:14:54.399 | *      |