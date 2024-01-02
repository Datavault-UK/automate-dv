Feature: [PIT-1SB] Point in Time
  Base PIT behaviour with one hub and one satellite - Base Loads

  # DATES
  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-01] Base load into a pit table from one satellite with dates with AS OF dates all in the past
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000   |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-01-BQ] Base load into a pit table from one satellite with dates with AS OF dates all in the past
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-29 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-30 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-29 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-30 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-29 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-30 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-02] Base load into a pit table from one satellite with dates with AS OF dates in the past and in between LDTS
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03 00:00:00.000   |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-02-BQ] Base load into a pit table from one satellite with dates with AS OF dates in the past and in between LDTS
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |

  @fixture.pit_one_sat
  Scenario: [PIT-1SB-03] Base load into a pit table from one satellite with dates with AS OF dates in between LDTS and some in the future
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
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
  Scenario: [PIT-1SB-04] Base load into a pit table from one satellite with dates with all AS OF dates in the future
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
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

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-05] Base load into a pit table from one satellite with dates with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
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

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-05-BQ] Base load into a pit table from one satellite with dates with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
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
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   |

  # TIMESTAMPS
  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-06] Base load into a pit table from one satellite with timestamps with al AS OF timestamps in the past
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 12:00:00.001 |
      | 2018-05-31 23:59:59.998 |
      | 2018-05-31 23:59:59.999 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.001 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 23:59:59.998 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 12:00:00.001 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.998 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 12:00:00.001 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.998 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-06-BQ] Base load into a pit table from one satellite with timestamps with al AS OF timestamps in the past
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 12:00:00.001 |
      | 2018-05-31 23:59:59.998 |
      | 2018-05-31 23:59:59.999 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.001 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 23:59:59.998 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 12:00:00.001 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.998 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 12:00:00.001 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.998 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-07] Base load into a pit table from one satellite with timestamps with some AS OF timestamps in the past and some in between LDTS
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.991 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.993 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 23:59:59.990 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.990 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.990 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 23:59:59.990 | md5('1003')                | 2018-06-01 12:00:00.001      |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-07-BQ] Base load into a pit table from one satellite with timestamps with some AS OF timestamps in the past and some in between LDTS
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.991 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.993 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 23:59:59.990 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.990 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.990 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 23:59:59.990 | md5('1003')                | 2018-06-01 12:00:00.001      |

  @fixture.pit_one_sat
  Scenario: [PIT-1SB-08] Base load into a pit table from one satellite with timestamps with AS OF timestamps in between LDTS and some in the future
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.001 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 12:00:00.001 |
      | 2018-06-01 23:59:59.999 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.999 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.999 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-01 00:00:00.001 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.001 | md5('1003')                | 2018-06-01 12:00:00.001      |
      | md5('1003') | 2018-06-01 23:59:59.999 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |

  @fixture.pit_one_sat
  Scenario: [PIT-1SB-09] Base load into a pit table from one satellite with timestamps with all AS OF timestamps in the future
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2019-06-02 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2019-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2019-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2019-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-10] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 12:00:00.001 |
      | 2018-06-01 23:59:59.998 |
      | 2018-06-01 23:59:59.999 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.998 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.999 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.998 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.999 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.001 | md5('1003')                | 2018-06-01 12:00:00.001      |
      | md5('1003') | 2018-06-01 23:59:59.998 | md5('1003')                | 2018-06-01 12:00:00.001      |
      | md5('1003') | 2018-06-01 23:59:59.999 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-10-BQ] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 12:00:00.001 |
      | 2018-06-01 23:59:59.998 |
      | 2018-06-01 23:59:59.999 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.998 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 23:59:59.999 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.998 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 23:59:59.999 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.001 | md5('1003')                | 2018-06-01 12:00:00.001      |
      | md5('1003') | 2018-06-01 23:59:59.998 | md5('1003')                | 2018-06-01 12:00:00.001      |
      | md5('1003') | 2018-06-01 23:59:59.999 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |

  # AS OF - LOWER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-11] Base load into a pit table from one satellite with timestamps where AS OF dates are in the future
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
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
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
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

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-12] Base load into a pit table from one satellite with timestamps where AS OF dates are in the past
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
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
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
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

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-12-BQ] Base load into a pit table from one satellite with timestamps where AS OF dates are in the past
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
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
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-29 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-30 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-29 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-30 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-29 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-30 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-13] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.002 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.001      |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.002      |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-13-BQ] Base load into a pit table from one satellite with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.002 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.001      |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.002      |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-14] Base load into a pit table from one satellite with dates where AS OF timestamps are in the future
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.001 |
      | 2018-06-01 12:00:00.001 |
      | 2018-06-02 00:00:00.001 |
    When I load the vault
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.001 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 12:00:00.001 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.001 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.001 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 12:00:00.001 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.001 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.001 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 12:00:00.001 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.001 | md5('1003')             | 2018-06-01 00:00:00.000   |

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-15] Base load into a pit table from one satellite with dates where AS OF timestamps are in the past
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-05-31 12:30:00.001 |
      | 2018-05-31 23:59:59.999 |
    When I load the vault
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 12:30:00.001 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 12:30:00.001 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 12:30:00.001 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-15-BQ] Base load into a pit table from one satellite with dates where AS OF timestamps are in the past
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-05-31 12:30:00.001 |
      | 2018-05-31 23:59:59.999 |
    When I load the vault
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 12:30:00.001 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 12:30:00.001 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 12:30:00.001 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |

  @not_bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-16] Base load into a pit table from one satellite with dates with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 00:00:00.001 |
      | 2018-06-01 23:59:59.999 |
      | 2018-06-02 00:00:00.001 |
    When I load the vault
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.001 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 23:59:59.999 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.001 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.001 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 23:59:59.999 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.001 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.001 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 23:59:59.999 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.001 | md5('1003')             | 2018-06-01 00:00:00.000   |

  @bigquery
  @fixture.pit_one_sat
  Scenario: [PIT-1SB-16-BQ] Base load into a pit table from one satellite with dates with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_1S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_1S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_1S |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 00:00:00.001 |
      | 2018-06-01 23:59:59.999 |
      | 2018-06-02 00:00:00.001 |
    When I load the vault
    Then the PIT_CUSTOMER_1S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 00:00:00.001 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-01 23:59:59.999 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.001 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.001 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-01 23:59:59.999 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.001 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.001 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-01 23:59:59.999 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.001 | md5('1003')             | 2018-06-01 00:00:00.000   |
