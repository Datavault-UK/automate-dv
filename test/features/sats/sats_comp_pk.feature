Feature: [SAT-COMP-PK] Satellites with composite PKs

  @fixture.satellite
  Scenario: [SAT-COMP-PK-01] Load data into a non-existent satellite
    Given the SATELLITE_COMP table does not exist
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | A        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | B        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | C        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | D        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the SATELLITE_COMP sat
    Then the SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK | HASHDIFF                                                   | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('A') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214\|\|A') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('B') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215\|\|B')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('C') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216\|\|C')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('D') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217\|\|D')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-COMP-PK-02] Load duplicated data into a non-existent satellite
    Given the SATELLITE_COMP table does not exist
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | A        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | B        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | B        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | F        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | C        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | D        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | H        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | H        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | J        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the SATELLITE_COMP sat
    Then the SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK | HASHDIFF                                                   | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('A') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214\|\|A') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('B') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215\|\|B')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('F') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215\|\|F')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('C') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216\|\|C')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('D') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217\|\|D')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('H') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217\|\|H')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('J') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217\|\|J')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-COMP-PK-03] Load data into an empty satellite where payload/hashdiff data is partially null and some PKs are NULL
    Given the SATELLITE_COMP sat is empty
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | A        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | B        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | C        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | D        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | <null>      | <null>   | <null>        | <null>       | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | <null>   | <null>        | 1988-02-11   | <null>          | 1993-01-01 | *      |
      | <null>      | F        | Frida         | <null>       | <null>          | 1993-01-01 | *      |
      | 1005        | F        | <null>        | <null>       | <null>          | 1993-01-01 | *      |
      | <null>      | <null>   | <null>        | 1988-02-11   | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | F        | Frida         | <null>       | 17-214-233-1218 | 1993-01-01 | *      |
      | 1006        | G        | <null>        | <null>       | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | H        | Frida         | 1988-02-11   | <null>          | 1993-01-01 | *      |
      | 1007        | J        | <null>        | 1988-02-11   | <null>          | 1993-01-01 | *      |
      | 1008        | H        | Frida         | <null>       | <null>          | 1993-01-01 | *      |
      | 1009        | AL       | Albert        | 2001-01-01   | <null>          | 1993-01-01 | *      |
      | 1010        | BN       | Ben           | <null>       | 17-214-233-1219 | 1993-01-01 | *      |
      | 1011        | CH       | <null>        | 1977-07-07   | 17-214-233-1221 | 1993-01-01 | *      |
      | <null>      | CH       | Charlie       | 1988-08-08   | 17-214-233-1222 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the SATELLITE_COMP sat
    Then the SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK  | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('A')  | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214\|\|A') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('B')  | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215\|\|B')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('C')  | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216\|\|C')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('D')  | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217\|\|D')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | md5('F')  | <null>        | <null>          | <null>       | md5('^^\|\|1005\|\|^^\|\|^^\|\|F')                         | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | md5('G')  | <null>        | 17-214-233-1218 | <null>       | md5('^^\|\|1006\|\|^^\|\|17-214-233-1218\|\|G')            | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | md5('J')  | <null>        | <null>          | 1988-02-11   | md5('1988-02-11\|\|1007\|\|^^\|\|^^\|\|J')                 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1008') | md5('H')  | Frida         | <null>          | <null>       | md5('^^\|\|1008\|\|FRIDA\|\|^^\|\|H')                      | 1993-01-01     | 1993-01-01 | *      |
      | md5('1009') | md5('AL') | Albert        | <null>          | 2001-01-01   | md5('2001-01-01\|\|1009\|\|ALBERT\|\|^^\|\|AL')            | 1993-01-01     | 1993-01-01 | *      |
      | md5('1010') | md5('BN') | Ben           | 17-214-233-1219 | <null>       | md5('^^\|\|1010\|\|BEN\|\|17-214-233-1219\|\|BN')          | 1993-01-01     | 1993-01-01 | *      |
      | md5('1011') | md5('CH') | <null>        | 17-214-233-1221 | 1977-07-07   | md5('1977-07-07\|\|1011\|\|^^\|\|17-214-233-1221\|\|CH')   | 1993-01-01     | 1993-01-01 | *      |