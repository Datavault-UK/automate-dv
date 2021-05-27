@fixture.set_workdir
Feature: Effectivity Satellites
  Exploring the auto end dating of effectivity satellite in the light of the bridge feature

# QUESTIONS:
# 1. Can there ever be opened a new (set of) relationship(s) in the eff_sat without closing the one(s) that are open?
# 2. What happens when multiple (new) ORDERS appear in the stage, but they have different ldts?
#   Does one keep each ORDER open only until the next ORDER's (in the same load) START DATE?
#   Or should they all be left open until the next load containing a new (set for the same ?

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] One load; going from an empty table to 3 ORDERS
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Two loads; going from 1 ORDER to another (new) ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |

  # TODO: test fails with both eff_sat behaviours
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Two loads; going from one ORDER to two ORDERS (1 new, 1 existent)
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
#      | 1001        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
#      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |

# OR

      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Two loads; going from 1 ORDER to 3 (new) ORDERS
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 103      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |

  # TODO: test fails (closes 1001/100 despite being in the 2nd stage)
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Two loads; going from 1 ORDER to 3 ORDERS (2 new, 1 existent)
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# OR
#      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |

  # TODO: test fails; eff_sat macro fails to recognise (upon 3rd load) that there are 3 ORDERS being open and, thus, only closes the first one
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Three loads; going from 1 ORDER to 3 (new) ORDERS and then back to 1 (new) ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 103      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 104      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|104') | md5('1001') | md5('104') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|104') | md5('1001') | md5('104') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

  # TODO: test fails; eff_sat macro fails to recognise (upon 3rd load) that there are 3 ORDERS being open and, thus, only closes the first one
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Three loads; going from 1 ORDER to 3 (new) ORDERS and then back to the initial ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 103      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

  # TODO: test fails
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Three loads; going from 1 ORDER to 3 (new) ORDERS and then back to 1 (existent) ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 103      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      # Close the whole set and open the first one again
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

# OR

#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      # Only close the 2nd and 3rd order while leaving the first one
#      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

