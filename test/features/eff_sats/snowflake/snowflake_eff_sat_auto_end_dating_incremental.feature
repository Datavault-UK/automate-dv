Feature: [SF-EFF-AU-INC] Effectively satellites, further incremental testing


  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-01] Load empty stage into a non existent eff sat - one cycle
  Given the EFF_SAT table does not exist
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT eff_sat
  Then the EFF_SAT table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-02] Load stage into a non existent eff sat - one cycle
  Given the EFF_SAT table does not exist
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT eff_sat
  Then the EFF_SAT table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

#"Flip flop" refers to a link record that has been modified and then later restored to the original state (Eg. ORDER_ID: BBB)
  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-03] Load "flip flop" stage into a non existent eff sat - two cycles
  Given the EFF_SAT table does not exist
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT eff_sat
  Then the EFF_SAT table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-04] Load mixed stage into a non existent eff sat - two cycles
  Given the EFF_SAT table does not exist
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 3001        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 5000        | EEE      | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT eff_sat
  Then the EFF_SAT table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-05] Load empty stage into an empty eff sat - two cycles
  Given the EFF_SAT eff_sat is empty
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT eff_sat
  Then the EFF_SAT table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-06] Load stage into an empty eff sat - one cycle
  Given the EFF_SAT eff_sat is empty
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT eff_sat
  Then the EFF_SAT table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-07] Load mixed stage into an empty eff sat - two cycles
  Given the EFF_SAT eff_sat is empty
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    | 3000        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT eff_sat
  Then the EFF_SAT table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-08] Load of empty stage into an already populated eff sat - one cycle
    Given the EFF_SAT eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-09] Load of mixed stage into an already populated eff sat - one cycle
    Given the EFF_SAT eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite
  Scenario: [SF-EFF-AU-INC-10] Load of mixed stage into an already populated eff sat - two cycles
    Given the EFF_SAT eff_sat is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-09 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    And I load the EFF_SAT eff_sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | 3001        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | 5000        | EEE      | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    When I load the EFF_SAT eff_sat
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
      | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
      | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |


