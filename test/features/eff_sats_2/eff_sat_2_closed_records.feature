Feature: [EFF2-CLD] Effectivity Satellites without automatic end-dating
  Tests for eff_sat (without automatic end-dating) loading closed records

  @fixture.eff_satellite_2
  Scenario: [EFF2-CLD-01] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-10     | 2020-01-11 | orders | FALSE  |
      | 4000        | CCC      | 2020-01-10     | 2020-01-11 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-10     | TRUE   | md5('1') | 2020-01-11 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-CLD-02] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat_2 is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-10     | 2020-01-11 | orders | FALSE  |
      | 4000        | CCC      | 2020-01-10     | 2020-01-11 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-10     | TRUE   | md5('1') | 2020-01-11 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-CLD-03] One link is changed and the active link is end dated
    Given the EFF_SAT eff_sat_2 is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | CCC      | 2020-01-10     | 2020-01-11 | orders | FALSE  |
      | 4000        | CCC      | 2020-01-10     | 2020-01-11 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-10     | TRUE   | md5('1') | 2020-01-11 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-CLD-04] Two incremental loads - flip flop (CCC changes from 3000 to 4000, and then back to 3000)
    Given the EFF_SAT eff_sat_2 is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | CCC      | 2020-01-10     | 2020-01-11 | orders | FALSE  |
      | 4000        | CCC      | 2020-01-10     | 2020-01-11 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-10     | TRUE   | md5('1') | 2020-01-11 | orders |
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | CCC      | 2020-01-11     | 2020-01-12 | orders | TRUE   |
      | 4000        | CCC      | 2020-01-11     | 2020-01-12 | orders | FALSE  |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-10     | TRUE   | md5('1') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-11     | FALSE  | md5('0') | 2020-01-12 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-11     | TRUE   | md5('1') | 2020-01-12 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-CLD-05] Two incremental loads - no flip flop (CCC changes from 3000 to 4000, and then to 5000)
    Given the EFF_SAT eff_sat_2 is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | CCC      | 2020-01-10     | 2020-01-11 | orders | FALSE  |
      | 4000        | CCC      | 2020-01-10     | 2020-01-11 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-10     | TRUE   | md5('1') | 2020-01-11 | orders |
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 5000        | CCC      | 2020-01-11     | 2020-01-12 | orders | TRUE   |
      | 4000        | CCC      | 2020-01-11     | 2020-01-12 | orders | FALSE  |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-10     | TRUE   | md5('1') | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | 2020-01-11     | FALSE  | md5('0') | 2020-01-12 | orders |
      | md5('5000\|\|CCC') | md5('5000') | md5('CCC') | 2020-01-11     | TRUE   | md5('1') | 2020-01-12 | orders |

  @fixture.eff_satellite_2
  Scenario: [EFF2-CLD-06] Two incremental loads - duplicate closed record
    Given the EFF_SAT eff_sat_2 is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF |  LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') |  2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') |  2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') |  2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | CCC      | 2020-01-10     | 2020-01-11 | orders | FALSE  |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
    Given the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-12 | orders | FALSE  |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-10     | FALSE  | md5('0') | 2020-01-11 | orders |
