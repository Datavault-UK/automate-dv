Feature: [SF-SEF-AUB] Effectivity Satellites
  Further depth of testing for the auto-end-dating of effectivity satellite - Base loads

  # ORDER_FK is DRIVING KEY
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_testing_auto_end_dating
  Scenario: [SF-SEF-AUB-001] One load; going from an empty table to 1 CUSTOMER per ORDER
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
    And I stage the STG_ORDER_CUSTOMER data
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_status
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_testing_auto_end_dating
  Scenario: [SF-SEF-AUB-002] One load; going from an empty table to the same CUSTOMER for 3 different ORDERS
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1001        | 102      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
    And I stage the STG_ORDER_CUSTOMER data
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_status
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_testing_auto_end_dating
  Scenario: [SF-SEF-AUB-003] One load; going from an empty table to 3 CUSTOMERS per ORDER
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1002        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1003        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
    And I stage the STG_ORDER_CUSTOMER data
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat_status
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |

  # CUSTOMER_FK is DRIVING KEY
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_status_testing_auto_end_dating
  Scenario: [SF-SEF-AUB-004] One load; going from an empty table to 3 ORDERS
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | 1001        | 102      | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
    And I stage the STG_CUSTOMER_ORDER data
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat_status
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE | STATUS  |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      | TRUE    |