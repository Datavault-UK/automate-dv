@fixture.set_workdir
Feature: Satellites

@fixture.satellite_bigquery
  Scenario: [BASE-LOAD] Load data into a non-existent satellite
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB            | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24 01:01:01 | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17 01:01:01 | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04 01:01:01 | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13 01:01:01 | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                       | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB          | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24 01:01:01\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24 01:01:01   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17 01:01:01\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17 01:01:01   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04 01:01:01\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04 01:01:01   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13 01:01:01\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13 01:01:01   | 1993-01-01     | 1993-01-01 | *      |