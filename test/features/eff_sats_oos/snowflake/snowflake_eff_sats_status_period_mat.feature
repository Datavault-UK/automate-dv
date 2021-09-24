Feature: [SF-SEF-PM] Effectivity Satellites Loaded using Period Materialization

  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-001] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-002] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat_oos is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-003] 2 loads, Link is Changed Back Again, driving key is ORDER_PK
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-11     | 2020-01-12 | orders | FALSE  |
      | 4000        | CCC      | 2020-01-11     | 2020-01-12 | orders | TRUE   |
      | 4000        | CCC      | 2020-01-12     | 2020-01-13 | orders | FALSE  |
      | 5000        | CCC      | 2020-01-12     | 2020-01-13 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-11     | 2020-01-12 | orders | FALSE  |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-11     | 2020-01-12 | orders | TRUE   |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-12     | 2020-01-13 | orders | FALSE  |
      | md5('5000\|\|CCC') | md5('5000') | md5('CCC') | 2020-01-12     | 2020-01-13 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-004] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | 5000        | EEE      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | 5000        | <null>   | 2020-01-12 | 9999-12-31 | 2020-01-12     | 2020-01-13 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10     | 2020-01-11 | orders | TRUE   |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-10     | 2020-01-11 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-005] Loading data into a populated eff sat; driving key is ORDER_PK
    Given the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 4000        | CCC      | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders | TRUE   |
      | 5000        | CCC      | 2020-01-12 | 9999-12-31 | 2020-01-12     | 2020-01-13 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-11     | 2020-01-12 | orders | FALSE  |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-11     | 2020-01-12 | orders | TRUE   |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-12     | 2020-01-13 | orders | FALSE  |
      | md5('5000\|\|CCC') | md5('5000') | md5('CCC') | 2020-01-12     | 2020-01-13 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-006] One load; going from an empty table to the same CUSTOMER for 3 different ORDERS
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-01     | 2020-01-01 | *      | TRUE   |
      | 1000        | BBB      | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | 1000        | CCC      | 2020-01-03     | 2020-01-03 | *      | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-01     | 2020-01-01 | *      | TRUE   |
      | md5('1000\|\|BBB') | md5('1000') | md5('BBB') | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | md5('1000\|\|CCC') | md5('1000') | md5('CCC') | 2020-01-03     | 2020-01-03 | *      | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-007] One load; and different number of CUSTOMERS per ldts; going from an empty table to 3 CUSTOMERS per ORDER
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-01     | 2020-01-01 | *      | TRUE   |
      | 2000        | AAA      | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | 3000        | AAA      | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | 4000        | AAA      | 2020-01-03     | 2020-01-03 | *      | TRUE   |
      | 5000        | AAA      | 2020-01-03     | 2020-01-03 | *      | TRUE   |
      | 6000        | AAA      | 2020-01-03     | 2020-01-03 | *      | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-01     | 2020-01-01 | *      | TRUE   |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-02     | 2020-01-02 | *      | FALSE  |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | md5('3000\|\|AAA') | md5('3000') | md5('AAA') | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | 2020-01-03     | 2020-01-03 | *      | FALSE  |
      | md5('3000\|\|AAA') | md5('3000') | md5('AAA') | 2020-01-03     | 2020-01-03 | *      | FALSE  |
      | md5('4000\|\|AAA') | md5('4000') | md5('AAA') | 2020-01-03     | 2020-01-03 | *      | TRUE   |
      | md5('5000\|\|AAA') | md5('5000') | md5('AAA') | 2020-01-03     | 2020-01-03 | *      | TRUE   |
      | md5('6000\|\|AAA') | md5('6000') | md5('AAA') | 2020-01-03     | 2020-01-03 | *      | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status
  Scenario: [SF-SEF-PM-008] One load; going from an empty table to 1 CUSTOMER per ORDER + flip-flop situation
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-01     | 2020-01-01 | *      | TRUE   |
      | 2000        | AAA      | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | 1000        | AAA      | 2020-01-03     | 2020-01-03 | *      | TRUE   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT eff_sat_oos by day
    And I insert by period into the EFF_SAT eff_sat_oos by day
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-01     | 2020-01-01 | *      | TRUE   |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-02     | 2020-01-02 | *      | FALSE  |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | 2020-01-02     | 2020-01-02 | *      | TRUE   |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | 2020-01-03     | 2020-01-03 | *      | FALSE  |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-03     | 2020-01-03 | *      | TRUE   |


