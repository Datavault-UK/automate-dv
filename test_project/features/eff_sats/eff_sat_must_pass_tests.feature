@fixture.set_workdir
Feature: Effectivity Satellites
  Exploring the auto end dating of effectivity satellite in the light of the bridge feature

# QUESTIONS:
# 1. Can there ever be opened a new (set of) relationship(s) in the eff_sat without closing the one(s) that are open?
# 2. What happens when multiple (new) ORDERS appear in the stage, but they have different ldts?
#   Does one keep each ORDER open only until the next ORDER's (in the same load) START DATE?
#   Or should they all be left open until the next load containing a new (set for the same)?

  
################## ORDER_FK is DRIVING KEY ##################

# --------------------- BASE LOAD ---------------------

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] One load; going from an empty table to 1 CUSTOMER per ORDER
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

# TODO: rank/period materialisation test
#  @fixture.enable_auto_end_date
#  @fixture.eff_satellite_testing_auto_end_dating
#  Scenario: [BASE-LOAD] One load with different ldts; going from an empty table to 1 CUSTOMER per ORDER
#    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
#    And the RAW_STAGE_ORDER_CUSTOMER table contains data
#      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
#      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1002        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1003        | 300      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#    And I create the STG_ORDER_CUSTOMER stage
#    When I load the LINK_ORDER_CUSTOMER link
#    Then the LINK_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
#      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 09:00:00.000 | *      |
#      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 18:00:00.000 | *      |
#    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
#    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] One load; going from an empty table to the same CUSTOMER for 3 different ORDERS
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1001        | 102      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

# TODO: rank/period materialisation test
#  @fixture.enable_auto_end_date
#  @fixture.eff_satellite_testing_auto_end_dating
#  Scenario: [BASE-LOAD] One load with different ldts; going from an empty table to the same CUSTOMER for 3 different ORDERS
#    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
#    And the RAW_STAGE_ORDER_CUSTOMER table contains data
#      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
#      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1001        | 102      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#    And I create the STG_ORDER_CUSTOMER stage
#    When I load the LINK_ORDER_CUSTOMER link
#    Then the LINK_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 18:00:00.000 | *      |
#    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
#    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] One load; going from an empty table to 3 CUSTOMERS per ORDER
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1002        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1003        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

# TODO: rank/period materialisation test
#  # TODO: fails to add closing records
#  @fixture.enable_auto_end_date
#  @fixture.eff_satellite_testing_auto_end_dating
#  Scenario: [BASE-LOAD] One load with different ldts; going from an empty table to 3 CUSTOMERS per ORDER
#    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
#    And the RAW_STAGE_ORDER_CUSTOMER table contains data
#      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
#      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1003        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#    And I create the STG_ORDER_CUSTOMER stage
#    When I load the LINK_ORDER_CUSTOMER link
#    Then the LINK_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
#      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 18:00:00.000 | *      |
#    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
#    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

# TODO: rank/period materialisation test
#  # TODO: fails to add closing records
#  @fixture.enable_auto_end_date
#  @fixture.eff_satellite_testing_auto_end_dating
#  Scenario: [BASE-LOAD] One load with different ldts and different number of CUSTOMERS per ldts; going from an empty table to 3 CUSTOMERS per ORDER
#    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
#    And the RAW_STAGE_ORDER_CUSTOMER table contains data
#      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
#      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1003        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1004        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1005        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1006        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#    And I create the STG_ORDER_CUSTOMER stage
#    When I load the LINK_ORDER_CUSTOMER link
#    Then the LINK_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
#      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 09:00:00.000 | *      |
#      | md5('1004\|\|100') | md5('1004') | md5('100') | 2018-06-01 18:00:00.000 | *      |
#      | md5('1005\|\|100') | md5('1005') | md5('100') | 2018-06-01 18:00:00.000 | *      |
#      | md5('1006\|\|100') | md5('1006') | md5('100') | 2018-06-01 18:00:00.000 | *      |
#    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
#    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#      | md5('1003\|\|100') | md5('1003') | md5('100') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#      | md5('1004\|\|100') | md5('1004') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#      | md5('1005\|\|100') | md5('1005') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#      | md5('1006\|\|100') | md5('1006') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

#  TODO: rank/period materialisation test
#  # TODO: fails to add closing records
#  @fixture.enable_auto_end_date
#  @fixture.eff_satellite_testing_auto_end_dating
#  Scenario: [BASE-LOAD] One load with different ldts; going from an empty table to 1 CUSTOMER per ORDER + flip-flop situation
#    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
#    And the RAW_STAGE_ORDER_CUSTOMER table contains data
#      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
#      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#    And I create the STG_ORDER_CUSTOMER stage
#    When I load the LINK_ORDER_CUSTOMER link
#    Then the LINK_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
#    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
#    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
#      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

# --------------------- INCREMENTAL LOAD ---------------------

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Three loads; adding new relationships in each load
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
# First load...
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1002        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1004        | 400      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1005        | 500      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 09:00:00.000 | *      |
      | md5('1005\|\|500') | md5('1005') | md5('500') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1005\|\|500') | md5('1005') | md5('500') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Three loads; the same CUSTOMER placing a varying number of ORDERS at different times
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
# First load...
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 103      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|103') | md5('1001') | md5('103') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] Three loads; going from an empty table to 1 CUSTOMER per ORDER + flip-flop situation
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
# First load...
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

###################  CUSTOMER_FK is DRIVING KEY ##################

# --------------------- BASE LOAD ---------------------
  
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] One load; going from an empty table to 3 ORDERS
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | 1001        | 102      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
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
#
#  @fixture.enable_auto_end_date
#  @fixture.eff_satellite_testing_auto_end_dating
#  Scenario: [BASE-LOAD] One load; going from an empty table to 3 ORDERS
#    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
#    And the RAW_STAGE_CUSTOMER_ORDER table contains data
#      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
#      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1001        | 101      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#      | 1001        | 102      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
#    And I create the STG_CUSTOMER_ORDER stage
#    When I load the LINK_CUSTOMER_ORDER link
#    Then the LINK_CUSTOMER_ORDER table should contain expected data
#      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | *      |
#    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
#    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
#      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
#      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

# --------------------- INCREMENTAL LOAD ---------------------   
    
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Two loads; going from 1 ORDER to another (new) ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
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
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
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

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Two loads; changing the ORDER to another ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
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
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
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

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Two loads; going from 1 ORDER to 3 (new) ORDERS
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
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
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1001        | 103      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
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

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Three loads; going from 1 ORDER to 3 (new) ORDERS and then back to 1 (new) ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
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
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1001        | 103      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
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
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 104      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
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

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Three loads; going from 1 ORDER to 3 (new) ORDERS and then back to the initial ORDER
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
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
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | 1001        | 103      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
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
      | CUSTOMER_ID | ORDER_ID | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
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
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
