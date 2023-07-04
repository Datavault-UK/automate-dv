Feature: [SAT] Sats loaded using Incremental Materialization

#[SAT-LD-02] should fail since both records have the same priority in the row_number() window function, so only one is selected at random
#alternatively this test would pass, if row_number() could partition by both pk and hashdiff which would result in both being inserted
#[SAT-LD-01] passes with current row_number() window function, because the second record is missed by "first_record_in_set" CTE but picked up in "unique_source_records"
  @fixture.satellite
  Scenario: [SAT-LD-01] Incremental load into non existent sat, where there are two earliest records with same PK and different hashdiffs
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Allie         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Allie         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLIE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-LD-01] Incremental load into non existent sat, where there are two earliest records with same PK and different hashdiffs
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Allie         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Alison        | 17-214-233-1214 | 1997-04-24   | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Allie         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLIE\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Alison        | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALISON\|\|17-214-233-1214') | 1993-01-03     | 1993-01-03 | *      |

  @fixture.satellite
  Scenario: [SAT-LD-01] Incremental load into non existent sat, where there are two earliest records with same PK and different hashdiffs
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Alex          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Allie         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Alison        | 17-214-233-1214 | 1997-04-24   | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Alex          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALEX\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Allie         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLIE\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Alison        | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALISON\|\|17-214-233-1214') | 1993-01-03     | 1993-01-03 | *      |


  @fixture.satellite
  Scenario: [SAT-LD-11] Incremental load into non existent sat, where there are two earliest records with same PK and different hashdiffs
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Alex          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Alexie        | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Allie         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Alison        | 17-214-233-1214 | 1997-04-24   | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Alex          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALEX\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Alexie        | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALEXIE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Allie         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLIE\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1001') | Alison        | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALISON\|\|17-214-233-1214') | 1993-01-03     | 1993-01-03 | *      |
