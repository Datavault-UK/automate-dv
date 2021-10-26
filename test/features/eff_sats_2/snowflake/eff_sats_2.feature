Feature: [SF-EEF2] Status Effectivity Satellites (eff sat 2)


  @fixture.enable_auto_end_date
  @fixture.eff_satellite_2
  Scenario: [SF-EEF2-01] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_2
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM | STATUS | HASHDIFF | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | 2020-01-09     | TRUE   | md5('1') | 2020-01-10 | orders |


