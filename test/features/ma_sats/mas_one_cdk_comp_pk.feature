Feature: [MAS-1CD-CP] Multi Active Satellites
  Base loads with MAS behaviour with one CDK and composite keys

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-CP-01] Load data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_COMP table does not exist
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1224 | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1234 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | BBB      | Bobby         | 17-214-233-1235 | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1003        | CCC      | Chaz          | 17-214-233-1226 | 1993-01-01 | *      |
      | 1003        | CCC      | Chaz          | 17-214-233-1236 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | DDD      | Don           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | DDD      | Dominik       | 17-214-233-1237 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the MULTI_ACTIVE_SATELLITE_COMP ma_sat
    Then the MULTI_ACTIVE_SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK   | HASHDIFF                                         | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|AAA')   | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1224\|\|AAA')   | Alice         | 17-214-233-1224 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1234\|\|AAA')   | Alice         | 17-214-233-1234 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|BBB')     | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1225\|\|BBB')     | Bob           | 17-214-233-1225 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOBBY\|\|17-214-233-1235\|\|BBB')   | Bobby         | 17-214-233-1235 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|CCC')    | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAZ\|\|17-214-233-1226\|\|CCC')    | Chaz          | 17-214-233-1226 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAZ\|\|17-214-233-1236\|\|CCC')    | Chaz          | 17-214-233-1236 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOM\|\|17-214-233-1217\|\|DDD')     | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DON\|\|17-214-233-1227\|\|DDD')     | Don           | 17-214-233-1227 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOMINIK\|\|17-214-233-1237\|\|DDD') | Dominik       | 17-214-233-1237 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-B-06] Load duplicated data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_COMP ma_sat is empty
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1224 | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1234 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1235 | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1226 | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1236 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1227 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1237 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the MULTI_ACTIVE_SATELLITE_COMP ma_sat
    Then the MULTI_ACTIVE_SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK   | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1224 | md5('1001\|\|ALICE\|\|17-214-233-1224\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1234 | md5('1001\|\|ALICE\|\|17-214-233-1234\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215\|\|BBB')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | Bob           | 17-214-233-1225 | md5('1002\|\|BOB\|\|17-214-233-1225\|\|BBB')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235\|\|BBB')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|CCC')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | Chad          | 17-214-233-1226 | md5('1003\|\|CHAD\|\|17-214-233-1226\|\|CCC')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | Chad          | 17-214-233-1236 | md5('1003\|\|CHAD\|\|17-214-233-1236\|\|CCC')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217\|\|DDD')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227\|\|DDD')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | Dom           | 17-214-233-1237 | md5('1004\|\|DOM\|\|17-214-233-1237\|\|DDD')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-CP-03] Load data into an empty multi-active satellite where some records have NULL CDK(s) or Attribute(s)
    Given the MULTI_ACTIVE_SATELLITE_COMP ma_sat is empty
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1224 | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1234 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | <null>   | Bob           | 17-214-233-1225 | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1235 | 1993-01-01 | *      |
      | 1004        | DDD      | <null>        | <null>          | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | <null>          | 1993-01-01 | *      |
      | 1004        | <null>   | <null>        | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1227 | 1993-01-01 | *      |
      | <null>      | FFF      | <null>        | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | FFF      | Frida         | 17-214-233-1218 | 1993-01-01 | *      |
      | 1005        | FFF      | <null>        | 17-214-233-1218 | 1993-01-01 | *      |
      | 1005        | <null>   | Frida         | 17-214-233-1228 | 1993-01-01 | *      |
      | <null>      | GGG      | <null>        | <null>          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the MULTI_ACTIVE_SATELLITE_COMP ma_sat
    Then the MULTI_ACTIVE_SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK   | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1224 | md5('1001\|\|ALICE\|\|17-214-233-1224\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1234 | md5('1001\|\|ALICE\|\|17-214-233-1234\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215\|\|BBB')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | Bob           | 17-214-233-1235 | md5('1002\|\|BOB\|\|17-214-233-1235\|\|BBB')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | Dom           | 17-214-233-1227 | md5('1004\|\|DOM\|\|17-214-233-1227\|\|DDD')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | md5('FFF') | <null>        | 17-214-233-1218 | md5('1005\|\|^^\|\|17-214-233-1218\|\|FFF')    | 1993-01-01     | 1993-01-01 | *      |