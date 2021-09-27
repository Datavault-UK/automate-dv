Feature: [SF-SEF-RM] Effectivity Satellites Loaded using Rank Materialization

  @fixture.eff_satellite_status
  Scenario: [SF-SEF-RM-001] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.eff_satellite_status
  Scenario: [SF-SEF-RM-002] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat_status is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.eff_satellite_status
  Scenario: [SF-SEF-RM-003] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 4000        | DDD      | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | 5000        | EEE      | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | 5000        | <null>   | 2020-01-12     | 2020-01-13 | orders | TRUE   |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the EFF_SAT eff_sat_status
    And I insert by rank into the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | 2020-01-11 | orders | TRUE   |