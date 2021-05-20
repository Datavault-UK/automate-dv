@fixture.set_workdir
Feature: Point-In-Time (PIT) table - Base PIT behaviour with one hub and two satellites

# todo: Add cycles tests

######################### BASE LOAD #########################

  # DATES
  @fixture.pit_two_sats
  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              |       | SAT_CUSTOMER_LOGIN   |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
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
    And I create the STG_CUSTOMER_LOGIN stage
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
     Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE         | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-02 00:00:00.000 | Laptop      | md5('LAPTOP\|\|2018-06-02 00:00:00.000') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-03 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-03 00:00:00.000')  | 2018-06-04     | 2018-06-04 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
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

  # TIMESTAMPS
  @fixture.pit_two_sats
  Scenario: [BASE-LOAD-TS] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
      |                 |       | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
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
    And I create the STG_CUSTOMER_LOGIN_TS stage
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
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME | SOURCE |
      | md5('1001') | 1001        | 2018-06-01    | *      |
      | md5('1002') | 1002        | 2018-06-01    | *      |
      | md5('1003') | 1003        | 2018-06-01    | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
     Then the SAT_CUSTOMER_LOGIN_TS table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE         | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.001 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.001') | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.002 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.002')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01 00:00:00.001 | 2018-06-01 00:00:00.001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.001 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.001')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.002 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.002')  | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.001 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.001') | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.002 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.002') | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
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

  # AS OF - LOWER GRANULARITY
  @fixture.pit_two_sats
  Scenario: [BASE-LOAD-LG] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF dates
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
      |                 |       | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
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
    And I create the STG_CUSTOMER_LOGIN_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the HUB_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME | SOURCE |
      | md5('1001') | 1001        | 2018-06-01    | *      |
      | md5('1002') | 1002        | 2018-06-01    | *      |
      | md5('1003') | 1003        | 2018-06-01    | *      |
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
     Then the SAT_CUSTOMER_LOGIN_TS table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE         | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM          | LOAD_DATETIME               | SOURCE |
      | md5('1001') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.001 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.001') | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.002 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.002')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01 00:00:00.001 | 2018-06-01 00:00:00.001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.001 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.001')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.002 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.002') | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.001 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.001') | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.002 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.002') | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS  | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000       | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999       | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999       | md5('1003')              | 2018-06-01 23:59:59.999    |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_two_sats
  Scenario: [BASE-LOAD-HG] Base load into a pit table from two satellites with dates with an encompassing range of AS OF timestamps
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
      |              |       | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
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
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-03 12:00:00.000 |
      | 2018-06-05 23:59:59.999 |
      | 2018-06-06 00:00:00.000 |
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
     Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE         | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-02 00:00:00.000 | Laptop      | md5('LAPTOP\|\|2018-06-02 00:00:00.000') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-03 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-03 00:00:00.000')  | 2018-06-04     | 2018-06-04 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
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

######################### INCREMENTAL LOAD #########################

  # DATES
  # todo: check results
  @fixture.pit_two_sats
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates into an already populated pit table from two satellites with dates
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              |       | SAT_CUSTOMER_LOGIN   |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-03 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-02 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-03 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-03 | *      |
      | 1001        | 2018-06-03      | Phone       | 2018-06-03 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-02 |
      | 2018-06-04 |
    When I load the vault
#    Given the HUB_CUSTOMER hub is already populated with data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1001') | 1001        | 2018-06-01  | *      |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    And the SAT_CUSTOMER_DETAILS sat is already populated with data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-02     | 2018-06-02 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
#    And the SAT_CUSTOMER_LOGIN sat is already populated with data
#      | CUSTOMER_PK | LAST_LOGIN_DATE | DEVICE_USED | HASHDIFF                    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1001') | 2018-06-02      | Laptop      | md5('LAPTOP\|\|2018-06-02') | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1001') | 2018-06-03      | Phone       | md5('PHONE\|\|2018-06-03')  | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-02     | 2018-06-02 | *      |
#      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1003') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | 2018-06-01      | Laptop      | md5('LAPTOP\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                | 0000000000000000      | 1900-01-01              |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01                | md5('1001')           | 2018-06-03              |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                | md5('1002')           | 2018-06-02              |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-03                | md5('1002')           | 2018-06-03              |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-02                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03                | md5('1003')           | 2018-06-01              |
    When the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-04 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-03      | Tablet      | 2018-06-04 | *      |
      | 1002        | 2018-06-02      | Tablet      | 2018-06-04 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-05 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-05 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-05 | *      |
      | 1004        | 2018-06-04      | Laptop      | 2018-06-04 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-01 |
      | 2018-06-03 |
      | 2018-06-05 |
    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1001') | 1001        | 2018-06-01  | *      |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#      | md5('1004') | 1004        | 2018-06-04  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-02     | 2018-06-02 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-04     | 2018-06-04 | *      |
#      | md5('1004') | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | md5('4 FORREST ROAD HAMPSHIRE\|\|1950-01-01\|\|DOM')   | 2018-06-05     | 2018-06-05 | *      |
#    Then the SAT_CUSTOMER_LOGIN table should contain expected data
#      | CUSTOMER_PK | LAST_LOGIN_DATE | DEVICE_USED | HASHDIFF                    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1001') | 2018-06-02      | Laptop      | md5('LAPTOP\|\|2018-06-02') | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1001') | 2018-06-03      | Phone       | md5('PHONE\|\|2018-06-03')  | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-02     | 2018-06-02 | *      |
#      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1003') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | 2018-06-01      | Laptop      | md5('LAPTOP\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1001') | 2018-06-03      | Tablet      | md5('PHONE\|\|2018-06-03')  | 2018-06-04     | 2018-06-04 | *      |
#      | md5('1002') | 2018-06-02      | Tablet      | md5('TABLET\|\|2018-06-02') | 2018-06-04     | 2018-06-04 | *      |
#      | md5('1004') | 2018-06-04      | Laptop      | md5('LAPTOP\|\|2018-06-04') | 2018-06-04     | 2018-06-04 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                | 0000000000000000      | 1900-01-01              |
      | md5('1001') | 2018-06-03 | md5('1001')             | 2018-06-01                | md5('1001')           | 2018-06-03              |
      | md5('1001') | 2018-06-05 | md5('1001')             | 2018-06-04                | md5('1001')           | 2018-06-04              |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                | md5('1002')           | 2018-06-01              |
      | md5('1002') | 2018-06-03 | md5('1002')             | 2018-06-03                | md5('1002')           | 2018-06-03              |
      | md5('1002') | 2018-06-05 | md5('1002')             | 2018-06-03                | md5('1002')           | 2018-06-04              |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-03 | md5('1003')             | 2018-06-03                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-05 | md5('1003')             | 2018-06-03                | md5('1003')           | 2018-06-05              |
      | md5('1004') | 2018-06-01 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1004') | 2018-06-03 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1004') | 2018-06-05 | md5('1004')             | 2018-06-05                | md5('1004')           | 2018-06-04              |

  # TIMESTAMPS
  # todo: check results
  @fixture.pit_two_sats
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF timestamps into an already populated pit table from two satellites with timestamps
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
      |                 |       | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
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
    And I create the STG_CUSTOMER_LOGIN_TS stage
#    Given the HUB_CUSTOMER_TS hub is already populated with data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
#      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
#    And the SAT_CUSTOMER_DETAILS_TS sat is already populated with data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      And the SAT_CUSTOMER_LOGIN_TS sat is already populated with data
#      | CUSTOMER_PK | LAST_LOGIN_DATE            | DEVICE_USED | HASHDIFF                                    | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
#      | md5('1001') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
#      | md5('1001') | 2018-06-01 00:00:00.000001 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000001') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
#      | md5('1001') | 2018-06-01 00:00:00.000002 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000002')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000001 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000001')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000002 | Tablet      | md5('TABLET\|\|018-06-01 00:00:00.000002')  | 2018-06-02 00:00:00.000000 | 2018-06-02 00:00:00.000000 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000000')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000001 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000001') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000002 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000002') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 12:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 12:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 00:00:00.002    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000      | md5('1002')              | 2018-06-01 00:00:00.001    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-05-31 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-01 23:59:59.999    |
    When the RAW_STAGE_DETAILS_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-02 12:00:00.001 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-02 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    When the RAW_STAGE_LOGIN_TS is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE |
      | 1001        | 2018-06-02 00:00:00.002 | Phone       | 2018-06-02 12:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.003 | Tablet      | 2018-06-03 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.003 | Phone       | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.004 | Tablet      | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.005 | Laptop      | 2018-06-02 00:00:00.000 | *      |
      | 1004        | 2018-06-02 12:00:00.002 | Phone       | 2018-06-02 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_LOGIN_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 12:00:00.000 |
      | 2018-06-03 00:00:00.000 |
    When I load the vault
#    Then the HUB_CUSTOMER_TS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
#      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1004') | 1004        | 2018-06-02 23:59:59.999999 | *      |
#    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-02 12:00:00.000001 | 2018-06-02 12:00:00.000001 | *      |
#      | md5('1004') | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | md5('4 FORREST ROAD HAMPSHIRE\|\|1950-01-01\|\|DOM')   | 2018-06-02 23:59:59.999999 | 2018-06-02 23:59:59.999999 | *      |
#    Then the SAT_CUSTOMER_LOGIN_TS table should contain expected data
#      | CUSTOMER_PK | LAST_LOGIN_DATE            | DEVICE_USED | HASHDIFF                                    | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
#      | md5('1001') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
#      | md5('1001') | 2018-06-01 00:00:00.000001 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000001') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
#      | md5('1001') | 2018-06-01 00:00:00.000002 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000002')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000001 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000001')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000002 | Tablet      | md5('TABLET\|\|018-06-01 00:00:00.000002')  | 2018-06-02 00:00:00.000000 | 2018-06-02 00:00:00.000000 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000000')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000001 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000001') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000002 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000002') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
#      | md5('1001') | 2018-06-02 00:00:00.000002 | Phone       | md5('PHONE\|\|2018-06-02 00:00:00.000002')  | 2018-06-02 12:00:00.000001 | 2018-06-02 12:00:00.000001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000002 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000002') | 2018-06-03 00:00:00.000000 | 2018-06-03 00:00:00.000000 | *      |
#      | md5('1004') | 2018-06-02 12:00:00.000002 | Phone       | md5('PHONE\|\|2018-06-02 12:00:00.000002')  | 2018-06-02 23:59:59.999999 | 2018-06-02 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000      | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                | 2018-06-02 12:00:00.001      | md5('1001')              | 2018-06-02 12:00:00.001    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999      | md5('1002')              | 2018-06-03 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999      | md5('1003')              | 2018-06-02 00:00:00.000    |
      | md5('1004') | 2018-06-02 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1004') | 2018-06-02 12:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000      | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1004') | 2018-06-03 00:00:00.000 | md5('1004')                | 2018-06-02 23:59:59.999      | md5('1004')              | 2018-06-02 23:59:59.999    |

  # AS OF - LOWER GRANULARITY
  @fixture.pit_two_sats
  Scenario: [INCR-LOAD-LG] Incremental load with the more recent AS OF dates into an already populated pit table from two satellites with timestamps
    Given the PIT_CUSTOMER_LG table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK  | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |       | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_LG |
      |                 |       | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
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
    And I create the STG_CUSTOMER_LOGIN_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
#    Then the HUB_CUSTOMER_TS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME | SOURCE |
#      | md5('1001') | 1001        | 2018-06-01    | *      |
#      | md5('1002') | 1002        | 2018-06-01    | *      |
#      | md5('1003') | 1003        | 2018-06-01    | *      |
#    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
#      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
#     Then the SAT_CUSTOMER_LOGIN_TS table should contain expected data
#      | CUSTOMER_PK | LAST_LOGIN_DATE         | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM          | LOAD_DATETIME               | SOURCE |
#      | md5('1001') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
#      | md5('1001') | 2018-06-01 00:00:00.001 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.001') | 2018-06-01 00:00:00.002 | 2018-06-01 00:00:00.002 | *      |
#      | md5('1001') | 2018-06-01 00:00:00.002 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.002')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01 00:00:00.001 | 2018-06-01 00:00:00.001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.001 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.001')  | 2018-06-01 12:00:00.001 | 2018-06-01 12:00:00.001 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.002 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.002') | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.001 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.001') | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.002 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.002') | 2018-06-01 23:59:59.999 | 2018-06-01 23:59:59.999 | *      |
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS  | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000       | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1002') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999       | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-05-31 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999       | md5('1003')              | 2018-06-01 23:59:59.999    |
    When the RAW_STAGE_DETAILS_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-01 12:00:00.001 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-02 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_DETAILS_TS stage
    When the RAW_STAGE_LOGIN_TS is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE |
      | 1001        | 2018-06-02 00:00:00.002 | Phone       | 2018-06-02 00:00:00.001 | *      |
      | 1002        | 2018-06-01 00:00:00.003 | Tablet      | 2018-06-03 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.003 | Phone       | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.004 | Tablet      | 2018-06-02 00:00:00.000 | *      |
      | 1003        | 2018-06-01 00:00:00.005 | Laptop      | 2018-06-02 00:00:00.000 | *      |
      | 1004        | 2018-06-02 12:00:00.002 | Phone       | 2018-06-02 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_LOGIN_TS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
    When I load the vault
    Then the PIT_CUSTOMER_LG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK | SAT_CUSTOMER_DETAILS_TS_LDTS  | SAT_CUSTOMER_LOGIN_TS_PK | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                | 2018-06-01 12:00:00.001       | md5('1001')              | 2018-06-01 12:00:00.001    |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                | 2018-06-01 12:00:00.001       | md5('1001')              | 2018-06-02 00:00:00.001    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999       | md5('1002')              | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                | 2018-06-01 23:59:59.999       | md5('1002')              | 2018-06-03 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                | 2018-06-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999       | md5('1003')              | 2018-06-02 00:00:00.000    |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                | 2018-06-01 23:59:59.999       | md5('1003')              | 2018-06-02 00:00:00.000    |
      | md5('1004') | 2018-06-01 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1004') | 2018-06-02 00:00:00.000 | 0000000000000000           | 1900-01-01 00:00:00.000       | 0000000000000000         | 1900-01-01 00:00:00.000    |
      | md5('1004') | 2018-06-03 00:00:00.000 | md5('1004')                | 2018-06-02 23:59:59.999       | md5('1004')              | 2018-06-02 23:59:59.999    |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_two_sats
  Scenario: [INCR-LOAD-HG] Incremental load with the more recent AS OF timestamps into an already populated pit table from two satellites with dates
    Given the PIT_CUSTOMER_HG table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK  | SAT                  | PIT             |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_HG |
      |              |       | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-03 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-02 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-03 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-02 | *      |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-02 | *      |
      | 1001        | 2018-06-03      | Phone       | 2018-06-03 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 23:59:59.999 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 12:00:00.000 |
      | 2018-06-02 23:59:59.999 |
      | 2018-06-03 00:00:00.000 |
    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
#      | md5('1001') | 1001        | 2018-06-01  | *      |
#      | md5('1002') | 1002        | 2018-06-01  | *      |
#      | md5('1003') | 1003        | 2018-06-01  | *      |
#    Then the SAT_CUSTOMER_DETAILS table should contain expected data
#      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *      |
#      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *      |
#     Then the SAT_CUSTOMER_LOGIN table should contain expected data
#      | CUSTOMER_PK | LAST_LOGIN_DATE         | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
#      | md5('1001') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-02     | 2018-06-02 | *      |
#      | md5('1001') | 2018-06-02 00:00:00.000 | Laptop      | md5('LAPTOP\|\|2018-06-02 00:00:00.000') | 2018-06-02     | 2018-06-02 | *      |
#      | md5('1001') | 2018-06-03 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-03 00:00:00.000')  | 2018-06-04     | 2018-06-04 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-02     | 2018-06-02 | *      |
#      | md5('1002') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-03     | 2018-06-03 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000')  | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
#      | md5('1003') | 2018-06-01 00:00:00.000 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000') | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-02 23:59:59.999 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-01 00:00:00.000 |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-02 00:00:00.000 |
      | md5('1002') | 2018-06-02 23:59:59.999 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-02 00:00:00.000 |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   | md5('1002')           | 2018-06-03 00:00:00.000 |
      | md5('1003') | 2018-05-31 23:59:59.999 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')             | 2018-06-01 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')             | 2018-06-02 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-02 23:59:59.999 | md5('1003')             | 2018-06-02 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
    When the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1992-04-24   | 2018-06-04 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire  | 1950-01-01   | 2018-06-05 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-03      | Tablet      | 2018-06-04 | *      |
      | 1002        | 2018-06-02      | Tablet      | 2018-06-04 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-05 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-05 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-05 | *      |
      | 1004        | 2018-06-02      | Laptop      | 2018-06-03 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-04 00:00:00.000 |
      | 2018-06-06 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_HG table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')             | 2018-06-01 00:00:00.000   | md5('1001')           | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')             | 2018-06-04 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')             | 2018-06-04 00:00:00.000   | md5('1001')           | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')             | 2018-06-01 00:00:00.000   | md5('1002')           | 2018-06-02 00:00:00.000 |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   | md5('1002')           | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')             | 2018-06-03 00:00:00.000   | md5('1002')           | 2018-06-04 00:00:00.000 |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')             | 2018-06-02 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')             | 2018-06-03 00:00:00.000   | md5('1003')           | 2018-06-05 00:00:00.000 |
      | md5('1004') | 2018-06-02 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   | 0000000000000000      | 1900-01-01 00:00:00.000 |
      | md5('1004') | 2018-06-04 00:00:00.000 | 0000000000000000        | 1900-01-01 00:00:00.000   | md5('1004')           | 2018-06-03 00:00:00.000 |
      | md5('1004') | 2018-06-06 00:00:00.000 | md5('1004')             | 2018-06-05 00:00:00.000   | md5('1004')           | 2018-06-03 00:00:00.000 |
