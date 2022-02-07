Feature: [EFF2-RM] Effectivity Satellites Loaded using Rank Materialization

  @fixture.eff_satellite_2
  Scenario: [EFF2-RM-01] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-RM-02] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat_2 is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-RM-03] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | TRUE   | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | TRUE   | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | TRUE   | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 4000        | DDD      | TRUE   | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | 5000        | EEE      | TRUE   | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | 5000        | <null>   | TRUE   | 2020-01-12     | 2020-01-13 | orders | TRUE   |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat_2
    And I insert by rank into the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10     | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | TRUE   | md5('1') | 2020-01-10     | 2020-01-11 | orders |