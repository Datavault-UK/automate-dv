Feature: [SF-EFH-MUL] Effectivity Satellites with multi-part keys

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-01] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | SPA       | RETAIL      | BUSSTHINK       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-02] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat_hashdiff is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | SPA       | RETAIL      | BUSSTHINK       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-03] No Effectivity Change when duplicates are loaded
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1000        | AAA      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 2000        | BBB      | SPA       | RETAIL      | BUSSTHINK       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
      | 3000        | CCC      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-09     | 2020-01-10 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-04] New Link record Added
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 4000        | DDD      | GER       | RETAIL      | BUSSTHINK       | TRUE   | 2020-01-10     | 2020-01-11 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('4000\|\|DDD\|\|GER\|\|RETAIL\|\|BUSSTHINK') | md5('4000') | md5('DDD') | md5('GER') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-10     | 2020-01-11 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-05] Link is Changed
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 4000        | CCC      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-11     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | FALSE  | md5('0') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-11     | 2020-01-12 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-06] 2 loads, Link is Changed Back Again, driving key is ORDER_PK,PLATFORM_PK,ORGANISATION_PK
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | FALSE  | md5('0') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-11     | 2020-01-12 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 5000        | CCC      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-12     | 2020-01-13 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | FALSE  | md5('0') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-11     | 2020-01-12 | orders |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | FALSE  | md5('0') | 2020-01-12     | 2020-01-13 | orders |
      | md5('5000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('5000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-12     | 2020-01-13 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-07] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | <null>   | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-11     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-08] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat is already closed
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | FALSE  | md5('0') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 3000        | <null>   | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-11     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | FALSE  | md5('0') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-09] No New Eff Sat Added if Secondary Foreign Key is NULL and Latest EFF Sat with Common DFK is Closed
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | <null>      | DDD      | GBR       | ONLINE      | DATAVAULT       | TRUE   | 2020-01-11     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_hashdiff_multipart
  Scenario: [SF-EFH-MUL-10] No New Eff Sat Added if DFK and SFK are both NULL
    Given the EFF_SAT eff_sat_hashdiff is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | STATUS | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | <null>      | <null>   | GBR       | <null>      | DATAVAULT       | TRUE   | 2020-01-11     | 2020-01-12 | orders |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_hashdiff
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | STATUS | HASHDIFF | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | TRUE   | md5('1') | 2020-01-09     | 2020-01-10 | orders |