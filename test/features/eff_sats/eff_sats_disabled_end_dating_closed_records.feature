Feature: [EFF-CLD] Effectivity Satellites without automatic end-dating
  Tests for eff_sat (without automatic end-dating) loading closed records using only dates

  @fixture.eff_satellite
  Scenario: [EFF-CLD-01] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | 4000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

  @fixture.eff_satellite
  Scenario: [EFF-CLD-02] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | 4000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

  @fixture.eff_satellite
  Scenario: [EFF-CLD-03] One link is changed and the active link is end dated
    Given the EFF_SAT eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | 4000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

  @fixture.eff_satellite
  Scenario: [EFF-CLD-04] Two incremental loads - flip flop (CCC changes from 3000 to 4000, and then back to 3000)
    Given the EFF_SAT eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | 4000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | 4000        | CCC      | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |

  @fixture.eff_satellite
  Scenario: [EFF-CLD-05] Two incremental loads - no flip flop (CCC changes from 3000 to 4000, and then to 5000)
    Given the EFF_SAT eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | 4000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 4000        | CCC      | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
      | 5000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
      | md5('5000\|\|CCC') | md5('5000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |

  @fixture.eff_satellite
  Scenario: [EFF-CLD-06] Two incremental loads - duplicate closed record
    Given the EFF_SAT eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |