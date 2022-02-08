Feature: [EFF2-DAU-INC] Effectively satellites, further incremental testing


  @fixture.eff_satellite_2_datetime
  Scenario: [EFF2-DAU-INC-01] Load mixed stage with one record changed into a non existent eff sat - one cycle
  Given the EFF_SAT_2 table does not exist
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT_2 eff_sat_2
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2000        | BBB      | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT_2 eff_sat_2
  Then the EFF_SAT_2 table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |

  @fixture.eff_satellite_2_datetime  
  Scenario: [EFF2-DAU-INC-02] Load mixed stage with one record changed and then reverted, into a non existent eff sat - two cycles
  Given the EFF_SAT_2 table does not exist
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT_2 eff_sat_2
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2000        | BBB      | FALSE  | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT_2 eff_sat_2
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2001        | BBB      | FALSE  | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 4000        | DDD      | FALSE  | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 4001        | DDD      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT_2 eff_sat_2
  Then the EFF_SAT_2 table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('4001\|\|DDD') | md5('4001') | md5('DDD') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |


  @fixture.eff_satellite_2_datetime  
  Scenario: [EFF2-DAU-INC-03] Load mixed stage with one record changed and then reverted, into an empty eff sat - two cycles
  Given the EFF_SAT_2 eff_sat_2 is empty
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT_2 eff_sat_2
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2000        | BBB      | FALSE  | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT_2 eff_sat_2
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2001        | BBB      | FALSE  | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 4000        | DDD      | FALSE  | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 4001        | DDD      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT_2 eff_sat_2
  Then the EFF_SAT_2 table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('4001\|\|DDD') | md5('4001') | md5('DDD') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |

  @fixture.eff_satellite_2_datetime  
  Scenario: [EFF2-DAU-INC-04] Load mixed stage with one changed record into already populated eff sat - one cycle
  Given the EFF_SAT_2 eff_sat_2 is already populated with data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2000        | BBB      | FALSE  | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT_2 eff_sat_2
  Then the EFF_SAT_2 table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |


 @fixture.eff_satellite_2_datetime  
  Scenario: [EFF2-DAU-INC-05] Load mixed stage with one record changed and then reverted, into already populated eff sat - two cycles
  Given the EFF_SAT_2 eff_sat_2 is already populated with data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
  And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2000        | BBB      | FALSE  | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 3000        | CCC      | FALSE  | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 3001        | CCC      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  And I load the EFF_SAT_2 eff_sat_2
    And the RAW_STAGE table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2001        | BBB      | FALSE  | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 3001        | CCC      | FALSE  | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 3002        | CCC      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 4000        | DDD      | FALSE  | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 4001        | DDD      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
  And I stage the STG_CUSTOMER data
  When I load the EFF_SAT_2 eff_sat_2
  Then the EFF_SAT_2 table should contain expected data
    | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('3002\|\|CCC') | md5('3002') | md5('CCC') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('4001\|\|DDD') | md5('4001') | md5('DDD') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |

