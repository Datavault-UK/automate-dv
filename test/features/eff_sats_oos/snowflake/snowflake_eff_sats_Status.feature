Feature: [SF-SEF] Status Effectivity Satellites


  @fixture.eff_satellite_status
  Scenario: [SF-SEF-001] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE    |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE    |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT_OOS eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |


  @fixture.eff_satellite_status
  Scenario: [SF-SEF-002] Load data into an empty effectivity satellite
    Given the EFF_SAT_OOS eff_sat_oos is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE    |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE    |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |


  @fixture.eff_satellite_status
  Scenario: [SF-SEF-003] No Effectivity Change when duplicates are loaded
    Given the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 1000        | AAA      | 2020-01-10     | 2020-01-11 | orders | TRUE    |
      | 2000        | BBB      | 2020-01-10     | 2020-01-11 | orders | TRUE    |
      | 3000        | CCC      | 2020-01-10     | 2020-01-11 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT_OOS eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |


  @fixture.eff_satellite_status
  Scenario: [SF-SEF-004] New Link record Added
    Given the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 1000        | AAA      | 2020-01-09     | 2020-01-11 | orders | TRUE    |
      | 2000        | BBB      | 2020-01-09     | 2020-01-11 | orders | TRUE    |
      | 3000        | CCC      | 2020-01-09     | 2020-01-11 | orders | TRUE    |
      | 4000        | DDD      | 2020-01-10     | 2020-01-11 | orders | TRUE    |
      | 5000        | EEE      | 2020-01-10     | 2020-01-11 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE    | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | TRUE    | 2020-01-11 | orders |


  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-005] Link is Changed
    Given the EFF_SAT eff_sat_OOS is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 4000        | CCC      | 2020-01-11     | 2020-01-12 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_OOS
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-11     | FALSE   | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-11     | TRUE    | 2020-01-12 | orders |


  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-006] 2 loads, Link is Changed Back Again, driving key is ORDER_PK
    Given the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-11     | FALSE   | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-11     | TRUE    | 2020-01-12 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 5000        | CCC      | 2020-01-12     | 2020-01-13 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-11     | FALSE   | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-11     | TRUE    | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-12     | FALSE   | 2020-01-13 | orders |
      | md5('5000\|\|CCC') | md5('5000') | md5('CCC') | 2020-01-12     | TRUE    | 2020-01-13 | orders |


  @fixture.eff_satellite_status
  Scenario: [SF-SEF-007] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE    | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | TRUE    | 2020-01-11 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 5000        | <null>   | 2020-01-12     | 2020-01-13 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS  | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE    | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE    | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | TRUE    | 2020-01-11 | orders |


  @fixture.eff_satellite_status
  Scenario: [SF-SEF-008] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat is already closed
    Given the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | FALSE  | 2020-01-11 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | 5000        | <null>   | 2020-01-12     | 2020-01-13 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | FALSE  | 2020-01-11 | orders |

  @fixture.eff_satellite_status
  Scenario: [SF-SEF-009] No New Eff Sat Added if Secondary Foreign Key is NULL and Latest EFF Sat with Common DFK Remains Open
    Given the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | <null>      | EEE      | 2020-01-12     | 2020-01-13 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | TRUE   | 2020-01-11 | orders |


  @fixture.eff_satellite_status
  Scenario: [SF-SEF-010] No New Eff Sat Added if DFK and SFK are both NULL
    Given the EFF_SAT_OOS eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS  |
      | <null>      | <null>   | 2020-01-12     | 2020-01-13 | orders | TRUE    |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | TRUE   | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | TRUE   | 2020-01-11 | orders |