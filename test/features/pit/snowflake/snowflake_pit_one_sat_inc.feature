Feature: [SF-PIT-1SI] Point in Time
  Base PIT behaviour with one hub and one satellite - Incremental Loads

  # DATES
  @fixture.pit_one_sat
  Scenario: [SF-PIT-1SI-001] Incremental load with the more recent AS OF dates into an already populated pit table from one satellite with dates
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-03 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-02 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-03 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-02 |
      | 2018-06-04 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-02 00:00:00.000   |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
    When the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-04 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-01 |
      | 2018-06-03 |
      | 2018-06-05 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')             | 2018-06-04 00:00:00.000   |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1004') | 2018-06-01 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1004') | 2018-06-03 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1004') | 2018-06-05 00:00:00.000 | md5('1004')             | 2018-06-05 00:00:00.000   |

  # TIMESTAMPS
  @fixture.pit_one_sat
  Scenario: [SF-PIT-1SI-002] Incremental load with the more recent AS OF timestamps into an already populated pit table from one satellite with timestamps
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
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
      | 2018-05-31 12:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 12:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
    When the RAW_STAGE_DETAILS_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-02 12:00:00.001 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-02 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 12:00:00.000 |
      | 2018-06-03 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                | 2018-06-02 12:00:00.001      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1004') | 2018-06-02 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1004') | 2018-06-02 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1004') | 2018-06-03 00:00:00.000 | md5('1004')                | 2018-06-02 23:59:59.999      |

  # AS OF - LOWER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [SF-PIT-1SI-003] Incremental load with the more recent AS OF dates into an already populated pit table from one satellite with timestamps
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
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
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
    When the RAW_STAGE_DETAILS_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-02 12:00:00.001 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-02 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
    When I load the vault
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                | 2018-06-02 12:00:00.001      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      |
      | md5('1004') | 2018-06-01 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1004') | 2018-06-02 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      |
      | md5('1004') | 2018-06-03 00:00:00.000 | md5('1004')                | 2018-06-02 23:59:59.999      |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [SF-PIT-1SI-004] Incremental load with the more recent AS OF timestamps into an already populated pit table from one satellite with dates
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-03 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-02 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-03 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 12:00:00.000 |
      | 2018-06-02 12:00:00.000 |
      | 2018-06-04 12:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 12:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-05-31 12:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 12:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-05-31 12:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')             | 2018-06-02 00:00:00.000   |
      | md5('1003') | 2018-06-04 12:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
    When the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-04 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-04 00:00:00.000 |
      | 2018-06-06 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-04 00:00:00.000   |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-04 00:00:00.000   |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-02 00:00:00.000   |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   |
      | md5('1004') | 2018-06-02 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1004') | 2018-06-04 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1004') | 2018-06-06 00:00:00.000 | md5('1004')             | 2018-06-05 00:00:00.000   |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [SF-PIT-1SI-005] Incremental load with the more recent AS OF timestamps into an already populated pit table from one satellite with dates
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 12:00:00.000 |
      | 2018-06-02 12:00:00.000 |
      | 2018-06-04 12:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 12:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
    When the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-03 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-04 00:00:00.000 |
      | 2018-06-06 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-03 00:00:00.000   |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-03 00:00:00.000   |
