@fixture.set_workdir
Feature: Out of Sequence Satellites

  Scenario: Inserts no new record if hashdiff matches previous loaddate's hashdiff
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_SAP_CUSTOMER | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_SAP_CUSTOMER | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_SAP_CUSTOMER | 1993-01-08 | *      |
    And the SAT_CUSTOMER sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I create the STG_CUSTOMER stage
    When I load the SAT_CUSTOMER ex_sat
    Then the SAT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  Scenario: Inserts a record if hashdiff does not matches previous loaddate's hashdiff but matches the next loaddate's hashdiff
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_SAP_CUSTOMER | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_SAP_CUSTOMER | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_SAP_CUSTOMER | 1993-01-08 | *      |
    And the SAT_CUSTOMER sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I create the STG_CUSTOMER stage
    When I load the SAT_CUSTOMER ex_sat
    Then the SAT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-05 | 1993-01-05     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |

  Scenario: Inserts a record if hashdiff doesn't matches previous loaddate's hashdiff and the previous loaddate's hashdiff matches the next loaddate's hashdiff
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-04 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-05 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | SAT_SAP_CUSTOMER | 1993-01-06 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | SAT_SAP_CUSTOMER | 1993-01-07 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | SAT_SAP_CUSTOMER | 1993-01-08 | *      |
    And the SAT_CUSTOMER sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | EFFECTIVE_FROM |
      | 1001        | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      | 1993-01-03     |
    And I create the STG_CUSTOMER stage
    When I load the SAT_CUSTOMER ex_sat
    Then the SAT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|CHRIS\|\|17-214-233-1214') | Chris         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | 1993-01-03     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-04 | 1993-01-04     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1215') | Alice         | 1997-04-24   | 17-214-233-1215 | 1993-01-06 | 1993-01-06     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1216') | Alice         | 1997-04-24   | 17-214-233-1216 | 1993-01-07 | 1993-01-07     | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|BOB\|\|17-214-233-1216')   | Bob           | 1997-04-24   | 17-214-233-1216 | 1993-01-08 | 1993-01-08     | *      |

  Scenario: Empty xts, empty sat fed by staging should result in one line in sat.

  Scenario: Late arriving sat is on 1992-12-31 is the same, pre-populated sat as above. Row inserted.

  Scenario: Late arriving sat is on 1992-12-31 is different, pre-populated sat as above. Row inserted.

  Scenario: Late arriving sat is on 1993-01-09 is the same, pre-populated as above. No insert.

  Scenario: Late arriving sat is on 1993-01-09 is different, pre-populated as above. Row inserted.

  Scenario: Several customers being processed. Repeat above scenarios with 3 customers. Feed late on same day for all customers.

  Scenario: Several customers mix and match.

  Scenario: Late arriving sat that has a customer with a NULL pk.




