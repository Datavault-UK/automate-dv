@fixture.set_workdir
Feature: XTS Customer

  @fixture.xts
  Scenario: [BASE-LOAD] Load record into an empty XTS
    Given the XTS xts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SAT_NAME         | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load data into a non-existent XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SAT_NAME         | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load duplicated data into a non-existent XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SAT_NAME         | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Subsequent loads with no timeline change
    Given the XTS xts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SAT_NAME         | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-02  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-03  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to multiple satellites
    Given the XTS xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Charlie         | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SAT_NAME          | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from numerous stages each containing feeds to one satellite
    Given the XTS xts is empty
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | SAT_NAME         | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_FIRST stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | SAT_NAME         | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_SECOND stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SAT_NAME         | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |


  @fixture.disable_union
  @fixture.xts
  Scenario: [BASE-LOAD] Loads from numerous stages each containing feeds to multiple satellites
    Given the XTS xts is empty
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | SAT_NAME          | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    And I load the XTS xts
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | SAT_NAME          | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SAT_NAME          | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |

