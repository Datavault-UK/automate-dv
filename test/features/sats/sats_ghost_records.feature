Feature: [SAT-GR] Implementing ghost records

  @fixture.satellite
  Scenario: [SAT-GR-DEMO] Create a ghost record from seed demo
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE          |
      | 00000000000000000000000000000000 | NULL          | NULL            | 1900-01-01   | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | DBTVAULT_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *               |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *               |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *               |


  Scenario: [SAT-GR-01] Load ghost record when satellite created
    Given the SATELLITE table does not exist
    And ghost records are enabled
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE          |
      | 00000000000 | 00000000000000000000000000000000                      | NULL          | NULL            | NULL         | 1900-01-01     | 1900-01-01 | DBTVAULT_SYSTEM |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *               |

  Scenario: [SAT-GR-02] Ghost record not inserted if satellite already exists
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE          |
      | 00000000000 | NULL          | NULL            | NULL         | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | DBTVAULT_SYSTEM |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *               |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *               |
    And ghost records are enabled
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE          |
      | 00000000000 | NULL          | NULL            | NULL         | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | DBTVAULT_SYSTEM |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *               |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *               |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *               |
      | md5('1005') | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *               |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *               |

  Scenario: [SAT-GR-03] Ghost record not inserted if satellite already exists
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |
    And ghost records are enabled
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |
