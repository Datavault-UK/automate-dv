Feature: [EFF2-AU-INC] Effectively satellites, further incremental testing


  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-01] Load empty stage into a non existent eff sat - one cycle
  Given the EFF_SAT_ORDER_CUSTOMER table does not exist
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000 | 2020-01-09 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000 | 2020-01-09 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000 | 2020-01-09 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATETIME | SOURCE |
  And I stage the STG_ORDER_CUSTOMER data
  When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
    | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-09 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-09 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-09 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-02] Load stage into a non existent eff sat - one cycle
  Given the EFF_SAT_ORDER_CUSTOMER table does not exist
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS  | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE    | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE    | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE    | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
    | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS  | HASHDIFF | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE    | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE    | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE   | md5('0') | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE    | md5('1') | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE    | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE    | md5('1') | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-03] Load mixed stage with record changed and reverted, into a non existent eff sat - two cycles
  Given the EFF_SAT_ORDER_CUSTOMER table does not exist
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000 | 2020-01-12 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
    | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | FALSE  | md5('0') | 2020-01-11 00:00:00.000 | 2020-01-12 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-11 00:00:00.000 | 2020-01-12 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000 | 2020-01-10 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000 | 2020-01-11 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-04] Load mixed stage into a non existent eff sat - two cycles
  Given the EFF_SAT_ORDER_CUSTOMER table does not exist
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 3001        | CCC      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
    | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-12 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-05] Load empty stage into an empty eff sat - two cycles
  Given the EFF_SAT_ORDER_CUSTOMER eff_sat_2 is empty
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATETIME | SOURCE |
  And I stage the STG_ORDER_CUSTOMER data
  When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
    | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-06] Load stage into an empty eff sat - one cycle
  Given the EFF_SAT_ORDER_CUSTOMER eff_sat_2 is empty
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
    | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-07] Load mixed stage into an empty eff sat - two cycles
  Given the EFF_SAT_ORDER_CUSTOMER eff_sat_2 is empty
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | 2000        | BBB      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | 3000        | CCC      | TRUE   | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  And the RAW_STAGE_ORDER_CUSTOMER table contains data
    | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
  And I stage the STG_ORDER_CUSTOMER data
  When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
  Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
    | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
    | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-08] Load of empty stage into an already populated eff sat - one cycle
    Given the EFF_SAT_ORDER_CUSTOMER eff_sat_2 is already populated with data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM | LOAD_DATETIME | SOURCE |
    And I stage the STG_ORDER_CUSTOMER data
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-09] Load of mixed stage into an already populated eff sat - one cycle
    Given the EFF_SAT_ORDER_CUSTOMER eff_sat_2 is already populated with data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    And I stage the STG_ORDER_CUSTOMER data
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2_testing_auto_end_dating
  Scenario: [EFF2-AU-INC-10] Load of mixed stage into an already populated eff sat - two cycles
    Given the EFF_SAT_ORDER_CUSTOMER eff_sat_2 is already populated with data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | 2001        | BBB      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | 4000        | DDD      | TRUE   | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
    And I stage the STG_ORDER_CUSTOMER data
    And I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | STATUS | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | 1000        | AAA      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | 2000        | BBB      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | 3001        | CCC      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | 5000        | EEE      | TRUE   | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_2
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM              | LOAD_DATETIME           | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | FALSE  | md5('0') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | md5('2001\|\|BBB') | md5('2001') | md5('BBB') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09 00:00:00.000     | 2020-01-09 00:00:00.000 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | FALSE  | md5('0') | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | md5('3001\|\|CCC') | md5('3001') | md5('CCC') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |
      | md5('4000\|\|DDD') | md5('4000') | md5('DDD') | TRUE   | md5('1') | 2020-01-10 00:00:00.000     | 2020-01-10 00:00:00.000 | orders |
      | md5('5000\|\|EEE') | md5('5000') | md5('EEE') | TRUE   | md5('1') | 2020-01-11 00:00:00.000     | 2020-01-11 00:00:00.000 | orders |


