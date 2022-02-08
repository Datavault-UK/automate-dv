Feature: [EFF2-PM] Effectivity Satellites Loaded using Period Materialization

  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-01] Load data into a non-existent effectivity satellite
    Given the EFF_SAT_2 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-02] Load data into an empty effectivity satellite
    Given the EFF_SAT_2 eff_sat_2 is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-03] 2 loads, Link is Changed Back Again, driving key is ORDER_PK
    Given the EFF_SAT_2 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | TRUE   | 2020-01-11     | 2020-01-12 | orders |
      | 4000        | CCC      | TRUE   | 2020-01-11     | 2020-01-12 | orders |
      | 4000        | CCC      | TRUE   | 2020-01-12     | 2020-01-13 | orders |
      | 5000        | CCC      | TRUE   | 2020-01-12     | 2020-01-13 | orders |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | FALSE  | md5('0') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | TRUE   | md5('1') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | FALSE  | md5('0') | 2020-01-12     | 2020-01-13 | orders |
      | md5('5000\|\|CCC') | md5('5000') | md5('CCC') | TRUE   | md5('1') | 2020-01-12     | 2020-01-13 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-04] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the EFF_SAT_2 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 4000        | DDD      | TRUE   | 2020-01-10     | 2020-01-11 | orders |
      | 5000        | EEE      | TRUE   | 2020-01-10     | 2020-01-11 | orders |
      | 5000        | <null>   | TRUE   | 2020-01-12     | 2020-01-13 | orders |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10     | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | TRUE   | md5('1') | 2020-01-10     | 2020-01-11 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-05] Loading data into a populated eff sat; driving key is ORDER_PK
    Given the EFF_SAT_2 eff_sat_2 is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 4000        | CCC      | TRUE   | 2020-01-11     | 2020-01-12 | orders |
      | 5000        | CCC      | TRUE   | 2020-01-12     | 2020-01-13 | orders |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | FALSE  | md5('0') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | TRUE   | md5('1') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | FALSE  | md5('0') | 2020-01-12     | 2020-01-13 | orders |
      | md5('5000\|\|CCC') | md5('5000') | md5('CCC') | TRUE   | md5('1') | 2020-01-12     | 2020-01-13 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-06] One load; going from an empty table to the same CUSTOMER for 3 different ORDERS
    Given the EFF_SAT_2 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-01     | 2020-01-01 | *      |
      | 1000        | BBB      | TRUE   | 2020-01-02     | 2020-01-02 | *      |
      | 1000        | CCC      | TRUE   | 2020-01-03     | 2020-01-03 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-01     | 2020-01-01 | *      |
      | md5('1000\|\|BBB') | md5('1000') | md5('BBB') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | *      |
      | md5('1000\|\|CCC') | md5('1000') | md5('CCC') | TRUE   | md5('1') | 2020-01-03     | 2020-01-03 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-07] One load; and different number of CUSTOMERS per ldts; going from an empty table to 3 CUSTOMERS per ORDER
    Given the EFF_SAT_2 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-01     | 2020-01-01 | *      |
      | 2000        | AAA      | TRUE   | 2020-01-02     | 2020-01-02 | *      |
      | 3000        | AAA      | TRUE   | 2020-01-02     | 2020-01-02 | *      |
      | 4000        | AAA      | TRUE   | 2020-01-03     | 2020-01-03 | *      |
      | 5000        | AAA      | TRUE   | 2020-01-03     | 2020-01-03 | *      |
      | 6000        | AAA      | TRUE   | 2020-01-03     | 2020-01-03 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-01     | 2020-01-01 | *      |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | FALSE  | md5('0') | 2020-01-02     | 2020-01-02 | *      |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | *      |
      | md5('3000\|\|AAA') | md5('3000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | *      |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | FALSE  | md5('0') | 2020-01-03     | 2020-01-03 | *      |
      | md5('3000\|\|AAA') | md5('3000') | md5('AAA') | FALSE  | md5('0') | 2020-01-03     | 2020-01-03 | *      |
      | md5('4000\|\|AAA') | md5('4000') | md5('AAA') | TRUE   | md5('1') | 2020-01-03     | 2020-01-03 | *      |
      | md5('5000\|\|AAA') | md5('5000') | md5('AAA') | TRUE   | md5('1') | 2020-01-03     | 2020-01-03 | *      |
      | md5('6000\|\|AAA') | md5('6000') | md5('AAA') | TRUE   | md5('1') | 2020-01-03     | 2020-01-03 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2
  Scenario: [EFF2-PM-08] One load; going from an empty table to 1 CUSTOMER per ORDER + flip-flop situation
    Given the EFF_SAT_2 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-01     | 2020-01-01 | *      |
      | 2000        | AAA      | TRUE   | 2020-01-02     | 2020-01-02 | *      |
      | 1000        | AAA      | TRUE   | 2020-01-03     | 2020-01-03 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    And I insert by period into the EFF_SAT_2 eff_sat_2 by day
    Then the EFF_SAT_2 table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-01     | 2020-01-01 | *      |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | FALSE  | md5('0') | 2020-01-02     | 2020-01-02 | *      |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | *      |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | FALSE  | md5('0') | 2020-01-03     | 2020-01-03 | *      |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-03     | 2020-01-03 | *      |


