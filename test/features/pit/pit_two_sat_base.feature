Feature: [PIT-2SB] Point in Time
  Base PIT behaviour with one hub and two satellites - Base Loads

  # DATES
  @not_bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-01] Base load into a pit table from two satellites with dates with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER_2S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_2S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_2S |
      |                 |      | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-02 | *      |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-02 | *      |
      | 1001        | 2018-06-03      | Phone       | 2018-06-04 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
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
    Then the PIT_CUSTOMER_2S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-01 00:00:00.000 |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-02 00:00:00.000 |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |

  @bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-01-BQ] Base load into a pit table from two satellites with dates with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER_2S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_2S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_2S |
      |                 |      | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-02 | *      |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-02 | *      |
      | 1001        | 2018-06-03      | Phone       | 2018-06-04 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
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
    Then the PIT_CUSTOMER_2S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-01 00:00:00.000 |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-02 00:00:00.000 |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000      | 1900-01-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |

  # TIMESTAMPS
  @not_bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-02] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
      |                 |      | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the RAW_STAGE_LOGIN_TS table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE |
      | 1001        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.001 | Laptop      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.002 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.001 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.002 | Tablet      | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.000 | Phone       | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.001 | Tablet      | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.002 | Laptop      | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_LOGIN_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 00:00:00.001 |
      | 2018-06-01 12:00:00.001 |
      | 2018-06-01 23:59:59.999 |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 00:00:00.001 |
    When I load the vault
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 12:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-01 23:59:59.999 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-02 00:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      | md5('1002')              | 2018-06-01 00:00:00.001    |
      | md5('1002') | 2018-06-01 12:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      | md5('1002')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-06-01 23:59:59.999 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.001 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.001 | md5('1003')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 12:00:00.001 | md5('1003')                | 2018-06-01 12:00:00.001      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 23:59:59.999 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |
      | md5('1003') | 2018-06-02 00:00:00.001 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |

  @bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-02-BQ] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
      |                 |      | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the RAW_STAGE_LOGIN_TS table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE |
      | 1001        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.001 | Laptop      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.002 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.001 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.002 | Tablet      | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.000 | Phone       | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.001 | Tablet      | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.002 | Laptop      | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_LOGIN_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 00:00:00.001 |
      | 2018-06-01 12:00:00.001 |
      | 2018-06-01 23:59:59.999 |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 00:00:00.001 |
    When I load the vault
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 12:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-01 23:59:59.999 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-02 00:00:00.001 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      | md5('1002')              | 2018-06-01 00:00:00.001    |
      | md5('1002') | 2018-06-01 12:00:00.001 | md5('1002')                | 2018-06-01 00:00:00.000      | md5('1002')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-06-01 23:59:59.999 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.001 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0x0000000000000000         | 1900-01-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.001 | md5('1003')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 12:00:00.001 | md5('1003')                | 2018-06-01 12:00:00.001      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 23:59:59.999 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |
      | md5('1003') | 2018-06-02 00:00:00.001 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |

  # AS OF - LOWER GRANULARITY
  @not_bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-03] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
      |                 |      | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the RAW_STAGE_LOGIN_TS table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE |
      | 1001        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.001 | Laptop      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.002 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.001 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.002 | Tablet      | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.000 | Phone       | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.001 | Tablet      | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.002 | Laptop      | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_LOGIN_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |

  @bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-03-BQ] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
      |                 |      | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the RAW_STAGE_LOGIN_TS table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE |
      | 1001        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.001 | Laptop      | 2018-06-01 00:00:00.002 | *      |
      | 1001        | 2018-06-01 00:00:00.002 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.001 | Phone       | 2018-06-01 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.002 | Tablet      | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.000 | Phone       | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.001 | Tablet      | 2018-06-01 23:59:59.999 | *      |
      | 1003        | 2018-06-01 00:00:00.002 | Laptop      | 2018-06-01 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_LOGIN_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0x0000000000000000         | 1900-01-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      | 0x0000000000000000       | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |

  # AS OF - HIGHER GRANULARITY
  @not_bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-04] Base load into a pit table from two satellites with dates with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_2S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
      |                 |      | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-02 | *      |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-02 | *      |
      | 1001        | 2018-06-03      | Phone       | 2018-06-04 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-03 12:00:00.000 |
      | 2018-06-05 23:59:59.999 |
      | 2018-06-06 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-03 12:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-05 23:59:59.999 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-01 00:00:00.000 |
      | md5('1002') | 2018-06-03 12:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-05 23:59:59.999 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-03 12:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-05 23:59:59.999 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |

  @bigquery
  @fixture.pit_two_sats
  Scenario: [PIT-2SB-04-BQ] Base load into a pit table from two satellites with dates with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_2S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
      |                 |      | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-02 | *      |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-02 | *      |
      | 1001        | 2018-06-03      | Phone       | 2018-06-04 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-03 12:00:00.000 |
      | 2018-06-05 23:59:59.999 |
      | 2018-06-06 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-03 12:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-05 23:59:59.999 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-01 00:00:00.000 |
      | md5('1002') | 2018-06-03 12:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-05 23:59:59.999 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-05 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0x0000000000000000      | 1900-01-01 00:00:00.000   | 0x0000000000000000    | 1900-01-01 00:00:00.000 |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-03 12:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-05 23:59:59.999 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-05 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
