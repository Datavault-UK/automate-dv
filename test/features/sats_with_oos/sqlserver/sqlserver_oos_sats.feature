Feature: [SQLS-SAT-OOS] Out of Sequence Satellites

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-001] Inserts no new records if hashdiff matches previous loaddate hashdiff
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS sat
    Then the SAT_CUSTOMER_OOS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-002] Inserts a record if hashdiff does not matches previous loaddate hashdiff but matches the next loaddate hashdiff
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS sat
    Then the SAT_CUSTOMER_OOS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-003] Inserts a record if hashdiff does not match previous loaddate hashdiff and the previous loaddate hashdiff matches the next loaddate hashdiff
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS sat
    Then the SAT_CUSTOMER_OOS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-004] Empty xts, empty sat fed by staging should result in one line in sat.
    Given the XTS xts is empty
    And the SAT_CUSTOMER_OOS sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS sat
    Then the SAT_CUSTOMER_OOS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-005] Late arriving sat is on 1992-12-31 is the same, pre-populated sat as above. Row inserted.
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME         | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS_EARLY | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS_EARLY | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS_EARLY | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS_EARLY sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1992-12-31 | *      | 1992-12-31     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS_EARLY sat
    Then the SAT_CUSTOMER_OOS_EARLY table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1992-12-31 | 1992-12-31     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-006] Late arriving sat is on 1992-12-31 is different, pre-populated sat as above. Row inserted.
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME         | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_EARLY | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS_EARLY | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS_EARLY | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS_EARLY | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS_EARLY sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1992-12-31 | *      | 1992-12-31     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS_EARLY sat
    Then the SAT_CUSTOMER_OOS_EARLY table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1992-12-31 | 1992-12-31    | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-007] Late arriving sat is on 1993-01-09 is the same, pre-populated as above. No insert.
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME        | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS_LATE | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS_LATE | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS_LATE | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS_LATE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-09 | *      | 1993-01-09     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS_LATE sat
    Then the SAT_CUSTOMER_OOS_LATE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-008] Late arriving sat is on 1993-01-09 is different, pre-populated as above. Row inserted.
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME        | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_LATE | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS_LATE | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS_LATE | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS_LATE | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS_LATE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1216 | 1993-01-09 | *      | 1993-01-09     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS_LATE sat
    Then the SAT_CUSTOMER_OOS_LATE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1216') | Chris         | 1997-04-24   | 17-214-233-1216 | 1993-01-09 | 1993-01-09     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-009] Several customers mix and match.
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-01 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-02 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-04 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS | 1993-01-05 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1215')  | SAT_CUSTOMER_OOS | 1993-01-06 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1216')  | SAT_CUSTOMER_OOS | 1993-01-07 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|GREGG\|\|17-214-233-1216') | SAT_CUSTOMER_OOS | 1993-01-08 | *      |
    And the SAT_CUSTOMER_OOS sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | Fred          | 1997-08-25   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1215')  | Fred          | 1997-08-25   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1216')  | Fred          | 1997-08-25   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|GREGG\|\|17-214-233-1216') | Gregg         | 1997-08-25   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1003        | Harry         | 1997-08-25   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
      | 1003        | Harry         | 1997-08-25   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I stage the STG_CUSTOMER data
    When I load the SAT_CUSTOMER_OOS sat
    Then the SAT_CUSTOMER_OOS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | Fred          | 1997-08-25   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|HARRY\|\|17-214-233-1214') | Harry         | 1997-08-25   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | Fred          | 1997-08-25   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1215')  | Fred          | 1997-08-25   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1216')  | Fred          | 1997-08-25   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|GREGG\|\|17-214-233-1216') | Gregg         | 1997-08-25   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  @fixture.out_of_sequence_satellite
  Scenario: [SQLS-SAT-OOS-010] Several customers mix and match with datetime instead of date..
    Given the XTS_TIMESTAMP xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME             | LOAD_DATETIME       | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:08 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:01 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:02 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:04 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:05 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:06 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:07 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:08 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:01 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:02 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:04 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:05 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1215')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:06 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1216')  | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:07 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|GREGG\|\|17-214-233-1216') | SAT_CUSTOMER_OOS_TIMESTAMP | 1993-01-01 01:01:08 | *      |
    And the SAT_CUSTOMER_OOS_TIMESTAMP sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME       | EFFECTIVE_FROM      | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 01:01:01 | 1993-01-01 01:01:01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-01 01:01:06 | 1993-01-01 01:01:06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-01 01:01:07 | 1993-01-01 01:01:07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-01 01:01:08 | 1993-01-01 01:01:08 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:01 | 1993-01-01 01:01:01 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:04 | 1993-01-01 01:01:04 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:05 | 1993-01-01 01:01:05 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-01 01:01:06 | 1993-01-01 01:01:06 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-01 01:01:07 | 1993-01-01 01:01:07 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-01 01:01:08 | 1993-01-01 01:01:08 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | Fred          | 1997-08-25   | 17-214-233-1214 | 1993-01-01 01:01:01 | 1993-01-01 01:01:01 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1215')  | Fred          | 1997-08-25   | 17-214-233-1215 | 1993-01-01 01:01:06 | 1993-01-01 01:01:06 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1216')  | Fred          | 1997-08-25   | 17-214-233-1216 | 1993-01-01 01:01:07 | 1993-01-01 01:01:07 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|GREGG\|\|17-214-233-1216') | Gregg         | 1997-08-25   | 17-214-233-1216 | 1993-01-01 01:01:08 | 1993-01-01 01:01:08 | *      |
    And the RAW_STAGE_TIMESTAMP table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME       | SOURCE | EFFECTIVE_FROM      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 01:01:03 | *      | 1993-01-01 01:01:03 |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 01:01:03 | *      | 1993-01-01 01:01:03 |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 01:01:03 | *      | 1993-01-01 01:01:03 |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:03 | *      | 1993-01-01 01:01:03 |
      | 1002        | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:03 | *      | 1993-01-01 01:01:03 |
      | 1003        | Harry         | 1997-08-25   | 17-214-233-1214 | 1993-01-01 01:01:03 | *      | 1993-01-01 01:01:03 |
      | 1003        | Harry         | 1997-08-25   | 17-214-233-1214 | 1993-01-01 01:01:03 | *      | 1993-01-01 01:01:03 |
    And I stage the STG_CUSTOMER_TIMESTAMP data
    When I load the SAT_CUSTOMER_OOS_TIMESTAMP sat
    Then the SAT_CUSTOMER_OOS_TIMESTAMP table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME       | EFFECTIVE_FROM      | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 01:01:01 | 1993-01-01 01:01:01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-01 01:01:06 | 1993-01-01 01:01:06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-01 01:01:07 | 1993-01-01 01:01:07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-01 01:01:08 | 1993-01-01 01:01:08 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:01 | 1993-01-01 01:01:01 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:03 | 1993-01-01 01:01:03 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|ETHAN\|\|17-214-233-1214') | Ethan         | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:04 | 1993-01-01 01:01:04 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1214')  | Chad          | 1999-12-07   | 17-214-233-1214 | 1993-01-01 01:01:05 | 1993-01-01 01:01:05 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1215')  | Chad          | 1999-12-07   | 17-214-233-1215 | 1993-01-01 01:01:06 | 1993-01-01 01:01:06 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|CHAD\|\|17-214-233-1216')  | Chad          | 1999-12-07   | 17-214-233-1216 | 1993-01-01 01:01:07 | 1993-01-01 01:01:07 | *      |
      | md5('1002') | md5('1999-12-07\|\|1002\|\|DOM\|\|17-214-233-1216')   | Dom           | 1999-12-07   | 17-214-233-1216 | 1993-01-01 01:01:08 | 1993-01-01 01:01:08 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | Fred          | 1997-08-25   | 17-214-233-1214 | 1993-01-01 01:01:01 | 1993-01-01 01:01:01 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|HARRY\|\|17-214-233-1214') | Harry         | 1997-08-25   | 17-214-233-1214 | 1993-01-01 01:01:03 | 1993-01-01 01:01:03 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1214')  | Fred          | 1997-08-25   | 17-214-233-1214 | 1993-01-01 01:01:04 | 1993-01-01 01:01:04 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1215')  | Fred          | 1997-08-25   | 17-214-233-1215 | 1993-01-01 01:01:06 | 1993-01-01 01:01:06 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|FRED\|\|17-214-233-1216')  | Fred          | 1997-08-25   | 17-214-233-1216 | 1993-01-01 01:01:07 | 1993-01-01 01:01:07 | *      |
      | md5('1003') | md5('1997-08-25\|\|1003\|\|GREGG\|\|17-214-233-1216') | Gregg         | 1997-08-25   | 17-214-233-1216 | 1993-01-01 01:01:08 | 1993-01-01 01:01:08 | *      |