@fixture.set_workdir
Feature: pit

  #todo: write a pit_two_sat fixture
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where all AS OF dates are in the future & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01  | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 | *      |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 | *      |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 | *      |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 | *      |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 | *      |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
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
     Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE            | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | 2019-01-01 02:00:00.000000 | Phone       | md5('PHONE\|\|2019-01-01 02:00:00.000')  | 2019-01-02     | 2019-01-02 | *      |
      | md5('1001') | 2019-01-02 03:00:00.000000 | Phone       | md5('PHONE\|\|2019-01-02 03:00:00.000')  | 2019-01-03     | 2019-01-03 | *      |
      | md5('1001') | 2019-01-03 01:00:00.000000 | Laptop      | md5('LAPTOP\|\|2019-01-03 01:00:00.000') | 2019-01-04     | 2019-01-04 | *      |
      | md5('1002') | 2019-01-01 05:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-01 05:00:00.000') | 2019-01-02     | 2019-01-02 | *      |
      | md5('1002') | 2019-01-02 06:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-02 06:00:00.000') | 2019-01-03     | 2019-01-03 | *      |
      | md5('1002') | 2019-01-03 08:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-03 08:00:00.000') | 2019-01-04     | 2019-01-04 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2016-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-03 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2016-06-04 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2016-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2016-06-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2016-06-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2016-06-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2016-06-03 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2016-06-04 | md5('1003')             | 2018-06-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where all AS OF dates are in the past & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01  | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-29 |
      | 2018-05-30 |
      | 2018-05-31 |
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
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-29 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-30 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-29 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-30 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-29 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-30 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where some AS OF dates are in the past & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01  | *      |
    And I create the STG_CUSTOMER_DETAILS stage
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
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01                |

  # AS OF DATES - LOWER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where AS OF dates are of lower granularity & all AS OF dates are in the future & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000002 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-03 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-04 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1002') | 2018-06-03 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1002') | 2018-06-04 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01 00:00:00.000002 |
      | md5('1003') | 2018-06-03 | md5('1003')             | 2018-06-01 00:00:00.000002 |
      | md5('1003') | 2018-06-04 | md5('1003')             | 2018-06-01 00:00:00.000002 |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where AS OF dates are of lower granularity & all AS OF dates are in the past & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-29 |
      | 2018-05-30 |
      | 2018-05-31 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000002 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000001 | 2018-06-01 00:00:00.000001 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000002 | 2018-06-01 00:00:00.000002 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-05-29 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-05-30 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where AS OF dates are are of lower granularity & some AS OF dates are in the past & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000001 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000002 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
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
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-02 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-02 | md5('1002')             | 2018-06-01 00:00:00.000001 |
      | md5('1003') | 2018-05-31 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-02 | md5('1003')             | 2018-06-01 00:00:00.000002 |

  # AS OF DATES - HIGHER GRANULARITY
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where AS OF dates are of higher granularity & all AS OF timestamps are in the future & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-06-01 00:00:00.000001 |
      | 2018-06-01 12:00:00.000001 |
      | 2018-06-02 00:00:00.000001 |
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
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-06-01 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 12:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 12:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 00:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 12:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 00:00:00.000001 | md5('1003')             | 2018-06-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where AS OF dates are of higher granularity & all AS OF timestamps are in the past & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 00:00:00.000000 |
      | 2018-05-31 12:30:00.000001 |
      | 2018-05-31 23:59:59.999999 |
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
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 00:00:00.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 12:30:00.000001 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD] Base load into a pit table from one satellite with dates where AS OF dates are are of higher granularity & some timestamps are in the past & the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                    |
      | 2018-05-31 23:59:59.999999 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-01 00:00:00.000001 |
      | 2018-06-01 23:59:59.999999 |
      | 2018-06-02 00:00:00.000001 |
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
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-01 23:59:59.999999 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2018-06-02 00:00:00.000001 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 1900-01-01                |
      | md5('1002') | 2018-06-01 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-01 23:59:59.999999 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2018-06-02 00:00:00.000001 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2018-05-31 23:59:59.999999 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 1900-01-01                |
      | md5('1003') | 2018-06-01 00:00:00.000001 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-01 23:59:59.999999 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2018-06-02 00:00:00.000001 | md5('1003')             | 2018-06-01                |

  # TIMESTAMPS
  #todo: needs a new fixture - @fixture.pit_one_sat_ts
  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of 15s & all as of date times are in the future
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-06-01 00:00:15.000000 |
      | 2019-06-01 00:00:30.000000 |
      | 2019-06-01 00:00:45.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2019-06-01 00:00:15.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2019-06-01 00:00:30.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2019-06-01 00:00:45.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-06-01 00:00:15.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-06-01 00:00:30.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-06-01 00:00:45.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-06-01 00:00:15.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-06-01 00:00:30.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-06-01 00:00:45.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of 15s & all as of date times are in the past
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 23:59:15.000000 |
      | 2018-05-31 23:59:30.000000 |
      | 2018-05-31 23:59:45.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1001') | 2018-05-31 23:59:15.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 23:59:30.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:15.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:30.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:15.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:30.000000 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01                |

  @fixture.pit_one_sat
  Scenario: [BASE-LOAD-TS] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of 15s & some as of date times are in the past
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire | 1988-02-12   | 2018-06-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-31 23:59:45.000000 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-01 00:00:15.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | Chad          | 3 Forrest road Hampshire | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  |
      | md5('1001') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2018-06-01 00:00:15.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2018-06-01 00:00:15.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2018-05-31 23:59:45.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2018-06-01 00:00:15.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
