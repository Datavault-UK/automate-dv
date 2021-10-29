Feature: [SF-EFO-DAU-OOS] Out of Sequence Satellites without automatic end-dating


  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-01]
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
      | md5('2000\|\|BBB') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('2000\|\|BBB') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('2000\|\|BBB') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('2000\|\|BBB') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('2000\|\|BBB') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('2000\|\|BBB') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
      | md5('3000\|\|CCC') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('3000\|\|CCC') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('3000\|\|CCC') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('4000\|\|CCC') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('4000\|\|CCC') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('4000\|\|CCC') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-05     | 2020-01-06 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-05     | 2020-01-06 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-05     | 2020-01-06 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 5000        | AAA      | 2020-01-07     | 2020-01-08 | orders | TRUE   |
      | 3000        | CCC      | 2020-01-07     | 2020-01-08 | orders | TRUE   |
      | 2000        | BBB      | 2020-01-07     | 2020-01-08 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-05     | 2020-01-06 | orders |
      | md5('2000\|\|BBB') | md5('2000') | md5('BBB') | TRUE   | md5('1') | 2020-01-05     | 2020-01-06 | orders |
      | md5('3000\|\|CCC') | md5('3000') | md5('CCC') | TRUE   | md5('1') | 2020-01-05     | 2020-01-06 | orders |
      | md5('4000\|\|CCC') | md5('4000') | md5('CCC') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('5000\|\|AAA') | md5('5000') | md5('AAA') | TRUE   | md5('1') | 2020-01-07     | 2020-01-08 | orders |


  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-02] ONE New Eff Sat added when the same record is added earlier than the start date of the EFF SAT
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-04 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-01     | 2020-01-01 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-01     | 2020-01-01 | orders |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |

  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-03] ONE New Eff Sat added when a new LINK change is established earlier than the start date of the EFF SAT
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-04 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | AAA      | 2020-01-01     | 2020-01-01 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('3000\|\|AAA') | md5('3000') | md5('AAA') | TRUE   | md5('1') | 2020-01-01     | 2020-01-01 | orders |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |

  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-04] NO New Eff Sat added when the same record is loaded while that link is still active
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-04     | 2020-01-04 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |


  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-05] TWO NEW inserts when a change to the link is loaded in the middle of a previously continuous link
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 2000        | AAA      | 2020-01-04     | 2020-01-04 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-04     | 2020-01-04 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |

      @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-06] TWO NEW inserts when a change to the link is loaded in the middle of a previously continuous link
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-12 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | AAA      | 2020-01-04     | 2020-01-04 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('3000\|\|AAA') | md5('3000') | md5('AAA') | TRUE   | md5('1') | 2020-01-04     | 2020-01-04 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |

  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-07] NO new inserts when the same link is loaded at the end.
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-04 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | 2020-01-12     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |

  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-08] ONE new inserts when the a change to the link is loaded with an earlier start date
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-04 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 2000        | AAA      | 2020-01-12     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-12     | 2020-01-12 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |

  @fixture.eff_satellite_oos
  Scenario:  [SF-EFO-DAU-09] ONE new inserts when the a change to the link is loaded with an earlier start date
    Given the XTS xts is already populated with data
      | CUSTOMER_ORDER_PK  | HASHDIFF | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-02 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-03 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-04 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-05 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-06 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-07 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-08 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-09 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-10 | orders |
      | md5('1000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-11 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-13 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-14 | orders |
      | md5('2000\|\|AAA') | md5('1') | EFF_SAT        | 2020-01-15 | orders |
    And the EFF_SAT eff_sat_oos is already populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | AAA      | 2020-01-12     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_oos
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA') | md5('1000') | md5('AAA') | TRUE   | md5('1') | 2020-01-02     | 2020-01-02 | orders |
      | md5('3000\|\|AAA') | md5('3000') | md5('AAA') | TRUE   | md5('1') | 2020-01-12     | 2020-01-12 | orders |
      | md5('2000\|\|AAA') | md5('2000') | md5('AAA') | TRUE   | md5('1') | 2020-01-13     | 2020-01-13 | orders |





