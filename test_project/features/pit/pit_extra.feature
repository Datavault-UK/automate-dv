@fixture.set_workdir
Feature: pit

  @fixture.pit
  Scenario: [BASE-PIT] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of a day & all as of dates are in the future
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
      | 2019-01-02 |
      | 2019-01-03 |
      | 2019-01-04 |
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
      | md5('1001') | 2019-01-02 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2019-01-03 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2019-01-04 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2019-01-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2019-01-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |

  @fixture.pit
  Scenario: [BASE-PIT] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of a day & all as of dates are in the past
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
      | 2018-01-02 |
      | 2018-01-03 |
      | 2018-01-04 |
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
      | md5('1001') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-04 | 0000000000000000        | 1900-01-01                |

  @fixture.pit
  Scenario: [BASE-PIT] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of a day & some as of dates are in the past
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
      | 2018-01-02 |
      | 2019-06-01 |
      | 2019-06-02 |
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
      | md5('1001') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2019-01-03 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2019-01-04 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |

  # TIMESTAMPS
  @fixture.pit
  Scenario: [BASE-PIT-TS] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of a day & all as of dates are in the future
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
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
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
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-01-02 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-01-03 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |
      | md5('1003') | 2019-01-04 00:00:00.000000 | md5('1003')             | 2018-06-01 00:00:00.000000 |

  @fixture.pit
  Scenario: [BASE-PIT-TS] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of a day & all as of dates are in the past
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
      | 2018-01-02 |
      | 2018-01-03 |
      | 2018-01-04 |
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
      | md5('1001') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-04 | 0000000000000000        | 1900-01-01                |

  @fixture.pit
  Scenario: [BASE-PIT-TS] Base load into a pit table from one satellite with dates where the AS OF table is already established with increments of a day & some as of dates are in the past
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
      | 2018-01-02 |
      | 2019-06-01 |
      | 2019-06-02 |
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
      | md5('1001') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1001') | 2019-01-03 | md5('1001')             | 2018-06-01                |
      | md5('1001') | 2019-01-04 | md5('1001')             | 2018-06-01                |
      | md5('1002') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |




























  #### NULLS ####
  # todo: these might not be of much help since the nulls are in the payload and they dont affect the behaviour of the PIT tables
  # so maybe these can be deleted/commented out; same with duplicates (if there are any duplicates tests below)
  @fixture.pit
  Scenario: [BASE-PIT-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the future
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2019-01-02 |
      | 2019-01-03 |
      | 2019-01-04 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1002') | 2019-01-02 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2019-01-02 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |

  @fixture.pit
  Scenario: [BASE-PIT-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & all as of dates are in the past
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-01-02 |
      | 2018-01-03 |
      | 2018-01-04 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1002') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2018-01-04 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-03 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2018-01-04 | 0000000000000000        | 1900-01-01                |

  @fixture.pit
  Scenario: [BASE-PIT-NULL] Base load into a pit table from one satellite with NULL values & with dates where the AS OF table is already established with increments of a day & some as of dates are in the past
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE   | SOURCE |
      | <null>      | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01  | *      |
      | 1002        | <null>        | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01  | *      |
      | 1003        | Chad          | <null>                   | 1988-02-12   | 2018-06-01  | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-01-02 |
      | 2019-06-01 |
      | 2019-06-02 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE   | SOURCE |
      | md5('1002') | 1002        | 2018-06-01  | *      |
      | md5('1003') | 1003        | 2018-06-01  | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                            | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | <null>        | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|^^') | 2018-06-01     | 2018-06-01 | *      |
      | md5('1003') | Chad          | <null>                   | 1988-02-12   | md5('^^\|\|1988-02-12\|\|CHAD')                     | 2018-06-01     | 2018-06-01 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS |
      | md5('1002') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1002') | 2019-01-03 | md5('1002')             | 2018-06-01                |
      | md5('1002') | 2019-01-04 | md5('1002')             | 2018-06-01                |
      | md5('1003') | 2019-01-02 | 0000000000000000        | 1900-01-01                |
      | md5('1003') | 2019-01-03 | md5('1003')             | 2018-06-01                |
      | md5('1003') | 2019-01-04 | md5('1003')             | 2018-06-01                |

  #### DUPLICATES #####
  #todo: probably a cycles duplicates simple test should suffice; no need for individual loads duplicates tests