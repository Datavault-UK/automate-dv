Feature: [SQLS-PIT-1SB] Point in Time
  Base PIT behaviour with one hub and one satellite - Base Loads

  # DATES
  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-01] Base load into a pit table from one satellite with dates with AS OF dates all in the past
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-29 |
      | 2018-05-30 |
      | 2018-05-31 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-29 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-30 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-29 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-30 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-29 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-30 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-02] Base load into a pit table from one satellite with dates with AS OF dates in the past and in between LDTS
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-04 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-03] Base load into a pit table from one satellite with dates with AS OF dates in between LDTS and some in the future
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-04 |
      | 2018-06-06 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-04] Base load into a pit table from one satellite with dates with all AS OF dates in the future
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-06 |
      | 2018-06-07 |
      | 2018-06-08 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-07 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-08 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1002') | 2018-06-07 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1002') | 2018-06-08 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-06-07 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-06-08 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-05] Base load into a pit table from one satellite with dates with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |

  # TIMESTAMPS
  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-06] Base load into a pit table from one satellite with timestamps with al AS OF timestamps in the past
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME              | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.997 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.997 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 12:00:00.000 |
      | 2018-05-31 23:59:59.993 |
      | 2018-05-31 23:59:59.997 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME              | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.997 | 2018-06-01 23:59:59.997 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.997 | 2018-06-01 23:59:59.997 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 23:59:59.993 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 23:59:59.997 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.993 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.997 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.993 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.997 | 0000000000000000           | 1900-01-01 00:00:00.000      |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-07] Base load into a pit table from one satellite with timestamps with some AS OF timestamps in the past and some in between LDTS
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.993 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.993 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.990 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 23:59:59.997 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.993 | 2018-06-01 23:59:59.993 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.993 | 2018-06-01 23:59:59.993 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.990 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.990 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.990 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 12:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.997 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.997 | md5('1002')                | 2018-06-01 23:59:59.993      |
      | md5('1003') | 2018-06-01 23:59:59.997 | md5('1003')                | 2018-06-01 23:59:59.993      |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-08] Base load into a pit table from one satellite with timestamps with AS OF timestamps in between LDTS and some in the future
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.997 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.003 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.997 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 12:00:00.007 |
      | 2018-06-01 23:59:59.997 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.997 | 2018-06-01 23:59:59.997 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.003 | 2018-06-01 12:00:00.003 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.997 | 2018-06-01 23:59:59.997 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.007 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.997 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.007 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.997 | md5('1002')                | 2018-06-01 23:59:59.997      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.997      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.007 | md5('1003')                | 2018-06-01 12:00:00.003      |
      | md5('1003') | 2018-06-01 23:59:59.997 | md5('1003')                | 2018-06-01 23:59:59.997      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.997      |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-09] Base load into a pit table from one satellite with timestamps with all AS OF timestamps in the future
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.996 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.996 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2019-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.996 | 2018-06-01 23:59:59.996 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.996 | 2018-06-01 23:59:59.996 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2019-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2019-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.996      |
      | md5('1003') | 2019-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.996      |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-010] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.997 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.007 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.997 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.997 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 12:00:00.003 |
      | 2018-06-01 23:59:59.993 |
      | 2018-06-01 23:59:59.997 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.997 | 2018-06-01 23:59:59.997 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.007 | 2018-06-01 12:00:00.007 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.997 | 2018-06-01 23:59:59.997 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.997 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.003 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.993 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.997 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.997 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.003 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.993 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.997 | md5('1002')                | 2018-06-01 23:59:59.997      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.997      |
      | md5('1003') | 2018-05-31 23:59:59.997 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.003 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 23:59:59.993 | md5('1003')                | 2018-06-01 12:00:00.007      |
      | md5('1003') | 2018-06-01 23:59:59.997 | md5('1003')                | 2018-06-01 23:59:59.997      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.997      |

  # AS OF - LOWER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-011] Base load into a pit table from one satellite with timestamps where AS OF dates are in the future
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.002 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.002 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.001 | 2018-06-01 00:00:00.001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.001      |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.001      |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.001      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.002      |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.002      |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.002      |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-012] Base load into a pit table from one satellite with timestamps where AS OF dates are in the past
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.002 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-29 |
      | 2018-05-30 |
      | 2018-05-31 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.002 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.001 | 2018-06-01 00:00:00.001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-29 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-30 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-29 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-30 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-29 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-30 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-013] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.010 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.020 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.010 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.020 | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.010 | 2018-06-01 00:00:00.010 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.020 | 2018-06-01 00:00:00.020 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.010      |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.020      |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-014] Base load into a pit table from one satellite with dates where AS OF timestamps are in the future
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.010 |
      | 2018-06-01 12:00:00.010 |
      | 2018-06-02 00:00:00.010 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 | *      |
      | md5('1002') | 1002        | 2018-06-01 | *      |
      | md5('1003') | 1003        | 2018-06-01 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.010 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 12:00:00.010 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.010 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.010 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 12:00:00.010 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.010 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.010 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 12:00:00.010 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.010 | md5('1003')             | 2018-06-01 00:00:00.000   |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-015] Base load into a pit table from one satellite with dates where AS OF timestamps are in the past
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-05-31 12:30:00.010 |
      | 2018-05-31 23:59:59.996 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 | *      |
      | md5('1002') | 1002        | 2018-06-01 | *      |
      | md5('1003') | 1003        | 2018-06-01 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 12:30:00.010 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 23:59:59.996 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 12:30:00.010 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 23:59:59.996 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 12:30:00.010 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 23:59:59.996 | 0000000000000000        | 1900-01-01 00:00:00.000   |

  @fixture.pit_one_sat
  Scenario: [SQLS-PIT-1SB-016] Base load into a pit table from one satellite with dates with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.996 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 00:00:00.010 |
      | 2018-06-01 23:59:59.996 |
      | 2018-06-02 00:00:00.010 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.996 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.010 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 23:59:59.996 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.010 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 23:59:59.996 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.010 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 23:59:59.996 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.010 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 23:59:59.996 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.010 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 23:59:59.996 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.010 | md5('1003')             | 2018-06-01 00:00:00.000   |


#  # NULLS
#  @fixture.pit_one_sat
#  Scenario: [SQLS-PIT-1SB-017] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the future
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUB          | LINK  | SAT                  | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I stage the STG_CUSTOMER_DETAILS data
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2019-01-02 |
#      | 2019-01-03 |
#      | 2019-01-04 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2019-01-02 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
#      | md5('1003') | 2019-01-02 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |
#
#  @fixture.pit_one_sat
#  Scenario: [SQLS-PIT-1SB-018] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the past
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUB          | LINK  | SAT                  | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I stage the STG_CUSTOMER_DETAILS data
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2018-01-02 |
#      | 2018-01-03 |
#      | 2018-01-04 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
#
#  @fixture.pit_one_sat
#  Scenario: [SQLS-PIT-1SB-019] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & some as of dates are in the past
#    Given the PIT table does not exist
#    And the raw vault contains empty tables
#      | HUB          | LINK  | SAT                  | PIT          |
#      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
#    And the RAW_STAGE_DETAILS table contains data
#      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
#      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
#      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
#      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
#    And I stage the STG_CUSTOMER_DETAILS data
#    And the AS_OF_DATE table is created and populated with data
#      | AS_OF_DATE |
#      | 2018-01-02 |
#      | 2019-06-01 |
#      | 2019-06-02 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
#    Then the PIT_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
#      | md5('1002') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
#      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
#      | md5('1003') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
#      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
#      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |