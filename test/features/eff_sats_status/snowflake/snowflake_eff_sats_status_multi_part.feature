Feature: [SF-SEF-MUL] Effectivity Satellites with multi-part keys

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-001] Load data into a non-existent effectivity satellite
    Given the EFF_SAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | GBR       | ONLINE      | DATAVAULT       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | SPA       | RETAIL      | BUSSTHINK       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | GBR       | ONLINE      | DATAVAULT       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-002] Load data into an empty effectivity satellite
    Given the EFF_SAT eff_sat_status is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | GBR       | ONLINE      | DATAVAULT       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | SPA       | RETAIL      | BUSSTHINK       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | GBR       | ONLINE      | DATAVAULT       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-003] No Effectivity Change when duplicates are loaded
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 1000        | AAA      | GBR       | ONLINE      | DATAVAULT       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 2000        | BBB      | SPA       | RETAIL      | BUSSTHINK       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | 3000        | CCC      | GBR       | ONLINE      | DATAVAULT       | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-004] New Link record Added
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 4000        | DDD      | GER       | RETAIL      | BUSSTHINK       | 2020-01-10     | 2020-01-11 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('4000\|\|DDD\|\|GER\|\|RETAIL\|\|BUSSTHINK') | md5('4000') | md5('DDD') | md5('GER') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-10     | 2020-01-11 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-005] Link is Changed
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 4000        | CCC      | GBR       | ONLINE      | DATAVAULT       | 2020-01-11     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-11     | 2020-01-12 | orders | FALSE  |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-11     | 2020-01-12 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-006] 2 loads, Link is Changed Back Again, driving key is ORDER_PK,PLATFORM_PK,ORGANISATION_PK
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-11     | 2020-01-12 | orders | FALSE  |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-11     | 2020-01-12 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 5000        | CCC      | GBR       | ONLINE      | DATAVAULT       | 2020-01-12     | 2020-01-13 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-11     | 2020-01-12 | orders | FALSE  |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-11     | 2020-01-12 | orders | TRUE   |
      | md5('4000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('4000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-12     | 2020-01-13 | orders | FALSE  |
      | md5('5000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('5000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-12     | 2020-01-13 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-007] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat Remain Open
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | <null>   | GBR       | ONLINE      | DATAVAULT       | 2020-01-11     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-008] No New Eff Sat Added if Driving Foreign Key is NULL and Latest EFF Sat is already closed
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | FALSE  |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | 3000        | <null>   | GBR       | ONLINE      | DATAVAULT       | 2020-01-11     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | FALSE  |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-009] No New Eff Sat Added if Secondary Foreign Key is NULL and Latest EFF Sat with Common DFK is Closed
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | <null>      | DDD      | GBR       | ONLINE      | DATAVAULT       | 2020-01-11     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_multipart
  Scenario: [SF-SEF-MUL-010] No New Eff Sat Added if DFK and SFK are both NULL
    Given the EFF_SAT eff_sat_status is already populated with data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID | PLATFORM_ID | ORGANISATION_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | <null>      | <null>   | GBR       | <null>      | DATAVAULT       | 2020-01-11     | 2020-01-12 | orders | TRUE   |
    And I stage the STG_CUSTOMER data
    When I load the EFF_SAT eff_sat_status
    Then the EFF_SAT table should contain expected data
      | CUSTOMER_ORDER_PK                                | CUSTOMER_PK | ORDER_PK   | NATION_PK  | PLATFORM_PK   | ORGANISATION_PK  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE | STATUS |
      | md5('1000\|\|AAA\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('1000') | md5('AAA') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('2000\|\|BBB\|\|SPA\|\|RETAIL\|\|BUSSTHINK') | md5('2000') | md5('BBB') | md5('SPA') | md5('RETAIL') | md5('BUSSTHINK') | 2020-01-09     | 2020-01-10 | orders | TRUE   |
      | md5('3000\|\|CCC\|\|GBR\|\|ONLINE\|\|DATAVAULT') | md5('3000') | md5('CCC') | md5('GBR') | md5('ONLINE') | md5('DATAVAULT') | 2020-01-09     | 2020-01-10 | orders | TRUE   |