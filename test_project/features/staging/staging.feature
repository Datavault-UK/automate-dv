@fixture.set_workdir
Feature: Staging

  @fixture.staging
  Scenario: Basic Staging
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I hash the stage
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

