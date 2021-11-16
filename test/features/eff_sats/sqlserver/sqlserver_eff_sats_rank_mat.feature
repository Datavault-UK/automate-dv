Feature: [SQLS-EFF-RM] Effectivity Satellites Loaded using Rank Materialization

  @fixture.eff_satellite
  Scenario: [SQLS-EFF-RM-01] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |

  @fixture.eff_satellite
  Scenario: [SQLS-EFF-RM-02] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |

  @fixture.eff_satellite
  Scenario: [SQLS-EFF-RM-03] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 5000        | EEE      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 5000        | <null>   | 2020-01-12 | 9999-12-31 | 2020-01-12     | 2020-01-13 | orders |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat
    And I insert by rank into the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |