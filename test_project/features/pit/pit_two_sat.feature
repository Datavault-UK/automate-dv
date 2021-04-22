@fixture.set_workdir
Feature: pit

#todo: write a pit_two_sat fixture

  # DATES
  # possible todo: might need to add times to the PIT (and possibly satelites and hubs too)
  # tothinkabout: the pit should get the right ldts, but what about the information mart that queries via the pit? Will it know to pick the right payload?
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from two satellites with dates with an encompassing range of AS OF dates
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
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
      | CUSTOMER_PK | LAST_LOGIN_DATE | DEVICE_USED | HASHDIFF                    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-02      | Laptop      | md5('LAPTOP\|\|2018-06-02') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-03      | Phone       | md5('PHONE\|\|2018-06-03')  | 2018-06-04     | 2018-06-04 | *      |
      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01      | Laptop      | md5('LAPTOP\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                | 0000000000000000      | 1900-01-01              |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                | md5('1001')           | 2018-06-02              |
      | md5('1001') | 2018-06-03 | md5('1001')             | 2018-06-01                | md5('1001')           | 2018-06-02              |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01                | md5('1001')           | 2018-06-04              |
      | md5('1001') | 2018-06-05 | md5('1001')             | 2018-06-01                | md5('1001')           | 2018-06-04              |
      | md5('1001') | 2018-06-06 | md5('1001')             | 2018-06-01                | md5('1001')           | 2018-06-04              |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                | md5('1002')           | 2018-06-01              |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                | md5('1002')           | 2018-06-02              |
      | md5('1002') | 2018-06-03 | md5('1002')             | 2018-06-01                | md5('1002')           | 2018-06-03              |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01                | md5('1002')           | 2018-06-03              |
      | md5('1002') | 2018-06-05 | md5('1002')             | 2018-06-05                | md5('1002')           | 2018-06-03              |
      | md5('1002') | 2018-06-06 | md5('1002')             | 2018-06-05                | md5('1002')           | 2018-06-03              |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                | 0000000000000000      | 1900-01-01              |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-03 | md5('1003')             | 2018-06-03                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-03                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-05 | md5('1003')             | 2018-06-05                | md5('1003')           | 2018-06-01              |
      | md5('1003') | 2018-06-06 | md5('1003')             | 2018-06-05                | md5('1003')           | 2018-06-01              |

  # TIMESTAMPS
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF timestamps
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2018-06-01 00:00:00.000000 | Tablet      | 2018-06-01 00:00:00.000002 | *      |
      | 1001        | 2018-06-01 00:00:00.000001 | Laptop      | 2018-06-01 00:00:00.000002 | *      |
      | 1001        | 2018-06-01 00:00:00.000002 | Phone       | 2018-06-01 12:00:00.000001 | *      |
      | 1002        | 2018-06-01 00:00:00.000000 | Tablet      | 2018-06-01 00:00:00.000001 | *      |
      | 1002        | 2018-06-01 00:00:00.000001 | Phone       | 2018-06-01 12:00:00.000001 | *      |
      | 1002        | 2018-06-01 00:00:00.000002 | Tablet      | 2018-06-02 00:00:00.000000 | *      |
      | 1003        | 2018-06-01 00:00:00.000000 | Phone       | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | 2018-06-01 00:00:00.000001 | Tablet      | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | 2018-06-01 00:00:00.000002 | Laptop      | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:59.999999 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-01 00:00:00.000001 |
      | 2018-06-01 12:00:00.000001 |
      | 2018-06-01 23:59:59.999999 |
      | 2018-06-02 00:00:00.000000 |
      | 2018-06-02 00:00:00.000001 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
     Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE            | DEVICE_USED | HASHDIFF                                    | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.000001 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000001') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.000002 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000002')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000001 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000001')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000002 | Tablet      | md5('TABLET\|\|018-06-01 00:00:00.000002')  | 2018-06-02 00:00:00.000000 | 2018-06-02 00:00:00.000000 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000000')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000001 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000001') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000002 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000002') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:00.000001 | md5('1001')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 12:00:00.000001 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-01 12:00:00.000001 |
      | md5('1001') | 2018-06-01 23:59:59.999999 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-01 12:00:00.000001 |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-01 12:00:00.000001 |
      | md5('1001') | 2018-06-02 00:00:00.000001 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-01 12:00:00.000001 |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:00.000001 | md5('1002')             | 2018-06-01 00:00:00.000000 | md5('1002')           | 2018-06-01 00:00:00.000001 |
      | md5('1002') | 2018-06-01 12:00:00.000001 | md5('1002')             | 2018-06-01 00:00:00.000000 | md5('1002')           | 2018-06-01 12:00:00.000001 |
      | md5('1002') | 2018-06-01 23:59:59.999999 | md5('1002')             | 2018-06-01 23:59:59.999999 | md5('1002')           | 2018-06-01 12:00:00.000001 |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002')             | 2018-06-01 23:59:59.999999 | md5('1002')           | 2018-06-02 00:00:00.000000 |
      | md5('1002') | 2018-06-02 00:00:00.000001 | md5('1002')             | 2018-06-01 23:59:59.999999 | md5('1002')           | 2018-06-02 00:00:00.000000 |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:00.000001 | md5('1003')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 12:00:00.000001 | md5('1003')             | 2018-06-01 12:00:00.000001 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 23:59:59.999999 | md5('1003')             | 2018-06-01 23:59:59.999999 | md5('1003')           | 2018-06-01 23:59:59.999999 |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003')             | 2018-06-01 23:59:59.999999 | md5('1003')           | 2018-06-01 23:59:59.999999 |
      | md5('1003') | 2018-06-02 00:00:00.000001 | md5('1003')             | 2018-06-01 23:59:59.999999 | md5('1003')           | 2018-06-01 23:59:59.999999 |

  # AS OF - LOWER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-LOWER-GRAN] Base load into a pit table from two satellites with timestamps with an encompassing range of AS OF dates
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.000001 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2018-06-01 00:00:00.000000 | Tablet      | 2018-06-01 00:00:00.000002 | *      |
      | 1001        | 2018-06-01 00:00:00.000001 | Laptop      | 2018-06-01 00:00:00.000002 | *      |
      | 1001        | 2018-06-01 00:00:00.000002 | Phone       | 2018-06-01 12:00:00.000001 | *      |
      | 1002        | 2018-06-01 00:00:00.000000 | Tablet      | 2018-06-01 00:00:00.000001 | *      |
      | 1002        | 2018-06-01 00:00:00.000001 | Phone       | 2018-06-01 12:00:00.000001 | *      |
      | 1002        | 2018-06-01 00:00:00.000002 | Tablet      | 2018-06-02 00:00:00.000000 | *      |
      | 1003        | 2018-06-01 00:00:00.000000 | Phone       | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | 2018-06-01 00:00:00.000001 | Tablet      | 2018-06-01 23:59:59.999999 | *      |
      | 1003        | 2018-06-01 00:00:00.000002 | Laptop      | 2018-06-01 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1001') | 1001        | 2018-06-01  | *      |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1003') | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
     Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE            | DEVICE_USED | HASHDIFF                                    | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.000001 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000001') | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
      | md5('1001') | 2018-06-01 00:00:00.000002 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000002')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000000 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000000') | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000001 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000001')  | 2018-06-01 12:00:00.000001 | 2018-06-01 12:00:00.000001 | *      |
      | md5('1002') | 2018-06-01 00:00:00.000002 | Tablet      | md5('TABLET\|\|018-06-01 00:00:00.000002')  | 2018-06-02 00:00:00.000000 | 2018-06-02 00:00:00.000000 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000000 | Phone       | md5('PHONE\|\|2018-06-01 00:00:00.000000')  | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000001 | Tablet      | md5('TABLET\|\|2018-06-01 00:00:00.000001') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
      | md5('1003') | 2018-06-01 00:00:00.000002 | Laptop      | md5('LAPTOP\|\|2018-06-01 00:00:00.000002') | 2018-06-01 23:59:59.999999 | 2018-06-01 23:59:59.999999 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    |
      | md5('1001') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-01 12:00:00.000001 |
      | md5('1002') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002')             | 2018-06-01 23:59:59.999999 | md5('1002')           | 2018-06-02 00:00:00.000000 |
      | md5('1003') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003')             | 2018-06-01 23:59:59.999999 | md5('1003')           | 2018-06-01 23:59:59.999999 |

  # AS OF - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-HIGHER-GRAN] Base load into a pit table from two satellites with dates with an encompassing range of AS OF timestamps
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
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
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:59.999999 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-03 12:00:00.000000 |
      | 2018-06-05 23:59:59.999999 |
      | 2018-06-06 00:00:00.000000 |
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
      | CUSTOMER_PK | LAST_LOGIN_DATE | DEVICE_USED | HASHDIFF                    | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-02      | Laptop      | md5('LAPTOP\|\|2018-06-02') | 2018-06-02     | 2018-06-02 | *      |
      | md5('1001') | 2018-06-03      | Phone       | md5('PHONE\|\|2018-06-03')  | 2018-06-04     | 2018-06-04 | *      |
      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-02     | 2018-06-02 | *      |
      | md5('1002') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-03     | 2018-06-03 | *      |
      | md5('1003') | 2018-06-01      | Phone       | md5('PHONE\|\|2018-06-01')  | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01      | Tablet      | md5('TABLET\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | 2018-06-01      | Laptop      | md5('LAPTOP\|\|2018-06-01') | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-03 12:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-02 00:00:00.000000 |
      | md5('1001') | 2018-06-05 23:59:59.999999 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-04 00:00:00.000000 |
      | md5('1001') | 2018-06-06 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2018-06-04 00:00:00.000000 |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 | md5('1002')           | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-06-03 12:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 | md5('1002')           | 2018-06-03 00:00:00.000000 |
      | md5('1002') | 2018-06-05 23:59:59.999999 | md5('1002')             | 2018-06-05 00:00:00.000000 | md5('1002')           | 2018-06-03 00:00:00.000000 |
      | md5('1002') | 2018-06-06 00:00:00.000000 | md5('1002')             | 2018-06-05 00:00:00.000000 | md5('1002')           | 2018-06-03 00:00:00.000000 |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 | md5('1003')           | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2018-06-03 12:00:00.000000 | md5('1003')             | 2018-06-03 00:00:00.000000 | md5('1003')           | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2018-06-05 23:59:59.999999 | md5('1003')             | 2018-06-05 00:00:00.000000 | md5('1003')           | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2018-06-06 00:00:00.000000 | md5('1003')             | 2018-06-05 00:00:00.000000 | md5('1003')           | 2018-06-01 00:00:00.000000 |
