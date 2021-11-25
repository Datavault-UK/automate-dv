Feature: [SF-EFF-DAU-INC] Effectively satellites, further incremental testing


  @fixture.eff_satellite
  Scenario: [SF-EFF-DAU-INC-01] Load mixed stage with one record changed into a non existent eff sat - one cycle
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
    | 2000        | BBB      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
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

  @fixture.eff_satellite
  Scenario: [SF-EFF-DAU-INC-02] Load mixed stage with one record changed and then reverted, into a non existent eff sat - two cycles
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
    | 2000        | BBB      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 2001        | BBB      | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 4000        | DDD      | 2020-01-10 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | 4001        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 5000        | EEE      | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
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
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | md5('4001\|\|DDD') | md5('4001') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |


  @fixture.eff_satellite
  Scenario: [SF-EFF-DAU-INC-03] Load mixed stage with one record changed and then reverted, into an empty eff sat - two cycles
  Given the EFF_SAT eff_sat is empty
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
    | 2000        | BBB      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 2001        | BBB      | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 4000        | DDD      | 2020-01-10 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | 4001        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 5000        | EEE      | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
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
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | md5('4001\|\|DDD') | md5('4001') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |

  @fixture.eff_satellite
  Scenario: [SF-EFF-DAU-INC-04] Load mixed stage with one changed record into already populated eff sat - one cycle
  Given the EFF_SAT eff_sat is already populated with data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 2000        | BBB      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
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


 @fixture.eff_satellite
  Scenario: [SF-EFF-DAU-INC-05] Load mixed stage with one record changed and then reverted, into already populated eff sat - two cycles
  Given the EFF_SAT eff_sat is already populated with data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-09     | 2020-01-10 | orders |
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 2000        | BBB      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | 2001        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 3000        | CCC      | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | 3001        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | 4000        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT eff_sat
    And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | START_DATE | END_DATE   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
    | 1000        | AAA      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 2001        | BBB      | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | 2000        | BBB      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 3001        | CCC      | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | 3002        | CCC      | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 4000        | DDD      | 2020-01-10 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | 4001        | DDD      | 2020-01-10 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | 5000        | EEE      | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
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
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09 | 2020-01-10 | 2020-01-10     | 2020-01-11 | orders |
    | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | 2020-01-09 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | md5('3002\|\|CCC') | md5('3002') | md5('CCC') | 2020-01-09 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-10     | 2020-01-11 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | 2020-01-10 | 2020-01-11 | 2020-01-11     | 2020-01-12 | orders |
    | md5('4001\|\|DDD') | md5('4001') | md5('DDD') | 2020-01-10 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | 2020-01-11 | 9999-12-31 | 2020-01-11     | 2020-01-12 | orders |

