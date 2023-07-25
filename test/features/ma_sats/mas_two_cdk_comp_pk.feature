Feature: [MAS-2CD-CP] Multi Active Satellites
  Base loads with MAS behaviour with two CDKs and multiple primary keys

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-CP-01] Load data into a non-existent multi-active satellite, where some customers have the same phone number but different extensions and others have different phone numbers but the same extensions
    Given the MAS_TWO_CDK_COMP table does not exist
    And the RAW_STAGE_TWO_CDK_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12301     | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12302     | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12303     | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 12311     | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 12312     | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 12313     | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1216 | 12321     | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1226 | 12321     | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1236 | 12321     | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1217 | 12331     | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1227 | 12331     | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1237 | 12331     | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK_COMP data
    When I load the MAS_TWO_CDK_COMP ma_sat
    Then the MAS_TWO_CDK_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK   | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12301\|\|AAA') | Alice         | 17-214-233-1214 | 12301     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12302\|\|AAA') | Alice         | 17-214-233-1214 | 12302     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12303\|\|AAA') | Alice         | 17-214-233-1214 | 12303     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|12311\|\|BBB')   | Bob           | 17-214-233-1215 | 12311     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|12312\|\|BBB')   | Bob           | 17-214-233-1215 | 12312     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|12313\|\|BBB')   | Bob           | 17-214-233-1215 | 12313     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|12321\|\|CCC')  | Chad          | 17-214-233-1216 | 12321     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAD\|\|17-214-233-1226\|\|12321\|\|CCC')  | Chad          | 17-214-233-1226 | 12321     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAD\|\|17-214-233-1236\|\|12321\|\|CCC')  | Chad          | 17-214-233-1236 | 12321     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOM\|\|17-214-233-1217\|\|12331\|\|DDD')   | Dom           | 17-214-233-1217 | 12331     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOM\|\|17-214-233-1227\|\|12331\|\|DDD')   | Dom           | 17-214-233-1227 | 12331     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOM\|\|17-214-233-1237\|\|12331\|\|DDD')   | Dom           | 17-214-233-1237 | 12331     | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-CP-02] Load duplicated data into an empty multi-active satellite
    Given the MAS_TWO_CDK_COMP ma_sat is empty
    And the RAW_STAGE_TWO_CDK_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12301     | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12302     | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12303     | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12303     | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 12311     | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 12312     | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1215 | 12313     | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1216 | 12321     | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1226 | 12321     | 1993-01-01 | *      |
      | 1003        | CCC      | Chad          | 17-214-233-1236 | 12321     | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1217 | 12331     | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1217 | 12331     | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1227 | 12331     | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1237 | 12331     | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK_COMP data
    When I load the MAS_TWO_CDK_COMP ma_sat
    Then the MAS_TWO_CDK_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK   | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12301\|\|AAA') | Alice         | 17-214-233-1214 | 12301     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12302\|\|AAA') | Alice         | 17-214-233-1214 | 12302     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12303\|\|AAA') | Alice         | 17-214-233-1214 | 12303     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|12311\|\|BBB')   | Bob           | 17-214-233-1215 | 12311     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|12312\|\|BBB')   | Bob           | 17-214-233-1215 | 12312     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|12313\|\|BBB')   | Bob           | 17-214-233-1215 | 12313     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|12321\|\|CCC')  | Chad          | 17-214-233-1216 | 12321     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAD\|\|17-214-233-1226\|\|12321\|\|CCC')  | Chad          | 17-214-233-1226 | 12321     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('CCC') | md5('1003\|\|CHAD\|\|17-214-233-1236\|\|12321\|\|CCC')  | Chad          | 17-214-233-1236 | 12321     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOM\|\|17-214-233-1217\|\|12331\|\|DDD')   | Dom           | 17-214-233-1217 | 12331     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOM\|\|17-214-233-1227\|\|12331\|\|DDD')   | Dom           | 17-214-233-1227 | 12331     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | md5('1004\|\|DOM\|\|17-214-233-1237\|\|12331\|\|DDD')   | Dom           | 17-214-233-1237 | 12331     | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-CP-03] Load data into an empty multi-active satellite where some records have NULL CDK(s) or Attribute(s)
    Given the MAS_TWO_CDK_COMP ma_sat is empty
    And the RAW_STAGE_TWO_CDK_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12301     | 1993-01-01 | *      |
      | 1001        | AAA      | Alice         | 17-214-233-1214 | 12302     | 1993-01-01 | *      |
      | 1001        | <null>   | Alice         | 17-214-233-1214 | 12303     | 1993-01-01 | *      |
      | 1002        | <null>   | Bob           | 17-214-233-1215 | 12311     | 1993-01-01 | *      |
      | 1002        | <null>   | Bob           | 17-214-233-1225 | 12311     | 1993-01-01 | *      |
      | 1002        | BBB      | Bob           | 17-214-233-1235 | 12311     | 1993-01-01 | *      |
      | 1004        | CCC      | <null>        | <null>          | <null>    | 1993-01-01 | *      |
      | <null>      | CCC      | <null>        | <null>          | 12321     | 1993-01-01 | *      |
      | <null>      | CCC      | <null>        | 17-214-233-1217 | <null>    | 1993-01-01 | *      |
      | <null>      | DDD      | Dom           | <null>          | <null>    | 1993-01-01 | *      |
      | 1004        | <null>   | Dom           | <null>          | <null>    | 1993-01-01 | *      |
      | <null>      | CCC      | <null>        | 17-214-233-1217 | 12321     | 1993-01-01 | *      |
      | 1004        | CCC      | <null>        | <null>          | 12321     | 1993-01-01 | *      |
      | <null>      | DDD      | Dom           | 17-214-233-1217 | <null>    | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | 17-214-233-1227 | <null>    | 1993-01-01 | *      |
      | 1004        | DDD      | Dom           | <null>          | 12321     | 1993-01-01 | *      |
      | 1004        | DDD      | <null>        | 17-214-233-1217 | 12321     | 1993-01-01 | *      |
      | <null>      | DDD      | Dom           | 17-214-233-1217 | <null>    | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK_COMP data
    When I load the MAS_TWO_CDK_COMP ma_sat
    Then the MAS_TWO_CDK_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK   | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1214 | 12301     | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12301\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | md5('AAA') | Alice         | 17-214-233-1214 | 12302     | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|12302\|\|AAA') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('BBB') | Bob           | 17-214-233-1235 | 12311     | md5('1002\|\|BOB\|\|17-214-233-1235\|\|12311\|\|BBB')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('DDD') | <null>        | 17-214-233-1217 | 12321     | md5('1004\|\|^^\|\|17-214-233-1217\|\|12321\|\|DDD')    | 1993-01-01     | 1993-01-01 | *      |