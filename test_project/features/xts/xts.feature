@fixture.set_workdir
Feature: XTS Customer

  @fixture.xts
  Scenario: [BASE-LOAD] Load record into an empty XTS
    Given the XTS xts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | SAT_NAME         |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | LOAD_DATE   | SAT_NAME         |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | 1993-01-01  | SAT_SAP_CUSTOMER |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | 1993-01-01  | SAT_SAP_CUSTOMER |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')    | 1993-01-01  | SAT_SAP_CUSTOMER |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | 1993-01-01  | SAT_SAP_CUSTOMER |

  @fixture.xts
  Scenario: [BASE-LOAD] Load data into a non-existent XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | SAT_NAME         |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      | SAT_SAP_CUSTOMER |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | LOAD_DATE   | SAT_NAME         |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | 1993-01-01  | SAT_SAP_CUSTOMER |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | 1993-01-01  | SAT_SAP_CUSTOMER |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')    | 1993-01-01  | SAT_SAP_CUSTOMER |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | 1993-01-01  | SAT_SAP_CUSTOMER |

  @fixture.xts
  Scenario: [BASE-LOAD] Load duplicated data into a non-existent XTS
    Given the XTS table does not exist
    And the STG_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | CUSTOMER_PK | HASHDIFF                                                | SAT_NAME         |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      | md5('1001') | md5('1001\|\|Alice\|\|1997-04-24\|\|17-214-233-1214')   | SAT_SAP_CUSTOMER |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      | md5('1001') | md5('1001\|\|Alice\|\|1997-04-24\|\|17-214-233-1214')   | SAT_SAP_CUSTOMER |
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | LOAD_DATE  | SAT_NAME  |
      | md5('1001') | md5('1001\|\|Alice\|\|1997-04-24\|\|17-214-233-1214') | 1993-01-01 | satellite |
