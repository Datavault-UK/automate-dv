@fixture.set_workdir
Feature: Effectivity Satellites
  Exploring the auto end dating of effectivity satellite in the light of the bridge feature

####################### BASE LOAD #######################

# ----------------------- ORDER_FK as DFK -----------------------  

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] Base load into a link and its effectivity satellite 
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] Base load into a link and its effectivity satellite; multiple SFKs for the same DFK; ORDER_PK is DFK & CUSTOMER_PK is SFK
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1111        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|100') | md5('1011') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1111\|\|100') | md5('1111') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|100') | md5('1011') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1111\|\|100') | md5('1111') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] Base load into a link and its effectivity satellite; multiple SFKs for the same DFK; CUSTOMER_PK is DFK & ORDER_PK is SFK
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

# ----------------------- CUSTOMER_FK as DFK -----------------------  
    
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] Base load into a link and its effectivity satellite 
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] Base load into a link and its effectivity satellite; multiple SFKs for the same DFK; ORDER_PK is DFK & CUSTOMER_PK is SFK
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1111        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|100') | md5('1011') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1111\|\|100') | md5('1111') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|100') | md5('1011') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1111\|\|100') | md5('1111') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [BASE-LOAD] Base load into a link and its effectivity satellite; multiple SFKs for the same DFK; CUSTOMER_PK is DFK & ORDER_PK is SFK
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    
####################### INCREMENTAL LOAD #######################
  
# ----------------------- ORDER_FK as DFK -----------------------  

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating; ORDER_PK is DFK & CUSTOMER_PK is SFK; 2 loads; one SFK per DFK 
    New orders or changed orders are assigned to existing customers, as well as to new ones
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
# First load...
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 111      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 12:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
  
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating; ORDER_PK is DFK & CUSTOMER_PK is SFK; 3 loads (with reverting to initial SFKs); one SFK per DFK  
    The changed orders are assigned to either an existing customer or to a new one; then they get reassigned back to the initial customer
    Given the EFF_SAT_ORDER_CUSTOMER table does not exist
# First load...
    And the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_ORDER_CUSTOMER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_CUSTOMER stage
    When I load the LINK_ORDER_CUSTOMER link
    Then the LINK_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_CUSTOMER eff_sat
    Then the EFF_SAT_ORDER_CUSTOMER table should contain expected data
      | ORDER_CUSTOMER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
    
# ----------------------- CUSTOMER_FK as DFK -----------------------

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating and new/closed orders to existing customers; CUSTOMER_PK is DFK & ORDER_PK is SFK; 2 loads; one SFK per DFK
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |

  # TODO: test fails
  # CUSTOMER 1002 gets ORDERS 201 and 202 in place of ORDER 200 at different ldts but in the same load
  #   The eff_sat macro should either insert a single closing record for ORDER 200 with the END_DATE equalling the START_DATE of ORDER 201
  # Now, in case we want to interpret ORDER 201 as a replacement to ORDER 200  and ORDER 202 as a replacement to ORDER 201,
  #   then we would need a closing record for ORDER 200 and a closing record for ORDER 201
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating and new orders to existing customers; CUSTOMER_PK is DFK & ORDER_PK is SFK; 2 loads; going from one SFK per DFK to two (new) SFKs per DFK
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 102      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 201      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 202      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|202') | md5('1002') | md5('202') | 2018-06-01 12:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|102') | md5('1001') | md5('102') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|202') | md5('1002') | md5('202') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
#      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
#      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 09:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
#      | md5('1002\|\|202') | md5('1002') | md5('202') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |

  # TODO: The test fails
  # We think CUSTOMER 1001 and 1002 should each be able to add a new relationship to the existing ones,
  #   but the macro doesn't seem to allow for multiple SFKs for the same DFK
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating and new orders to existing customers; CUSTOMER_PK is DFK & ORDER_PK is SFK; 2 loads; going from one SFK per DFK to two SFK per DFK
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 201      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|201') | md5('1002') | md5('201') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |

  # TODO: test fails
  # We try to get CUSTOMER 1001 to go from being linked with ORDER 100 to being linked with ORDER 100 and ORDER 200
  #   CUSTOMER 1002 / ORDER 200 link should remain open.
  # Then, also get CUSTOMER 1003 to go from being linked with ORDER 300 to being linked with ORDER 300 and ORDER 400
  #   CUSTOMER 1004 / ORDER 400 link should remain open.
  # But what actually happens is that CUSTOMER 100 and CUSTOMER 300 each "lose" their initial ORDERS (100 and 300, respectively)
  #   in order to link to the new ORDERS
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating and adding an open order to an existing customer; CUSTOMER_PK is DFK & ORDER_PK is SFK; 2 loads; going from one SFK per DFK to two SFK per DFK
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 400      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|200') | md5('1001') | md5('200') | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|400') | md5('1003') | md5('400') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|200') | md5('1001') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1003\|\|400') | md5('1003') | md5('400') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |

  # Interestingly enough, when news CUSTOMER (1011 andd 1012) get multiple ORDERS in the same load (be them at the same LDTS or not),
  # the multiple SKFs are allowed to coexist;
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating and two new orders each to two new customers; CUSTOMER_PK is DFK & ORDER_PK is SFK; 2 loads
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
## Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1011        | 111      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 112      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 211      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 212      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 09:00:00.000 | *      |
      | md5('1011\|\|112') | md5('1011') | md5('112') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|211') | md5('1012') | md5('211') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|212') | md5('1012') | md5('212') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1011\|\|112') | md5('1011') | md5('112') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|211') | md5('1012') | md5('211') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|212') | md5('1012') | md5('212') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |

  # TODO: the test fails
  # The 1st load has 4 DFK, each with an SFK;
  # 2nd load gets two new DFKs (1011, 1012) each with TWO SFKs (111 & 112, 211 & 212), no issues
  # 3rd load, CUSTOMER 1011 tries to keep only 111 (which is the first ORDER associated with C. 1011), no issues
  # then C. 1012 tries to keep ORDER 212 (the one loaded and inserted the 2nd in the eff_sat), but no change gets triggered in the eff_sat
  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating and two new orders each to two new customers, then closes one order for each customer;
    CUSTOMER_PK is DFK & ORDER_PK is SFK; 3 loads
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
## Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1011        | 111      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 112      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 211      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 212      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 09:00:00.000 | *      |
      | md5('1011\|\|112') | md5('1011') | md5('112') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|211') | md5('1012') | md5('211') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|212') | md5('1012') | md5('212') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1011\|\|112') | md5('1011') | md5('112') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|211') | md5('1012') | md5('211') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|212') | md5('1012') | md5('212') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1011        | 111      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 212      | 2018-06-02 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 09:00:00.000 | *      |
      | md5('1011\|\|112') | md5('1011') | md5('112') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|211') | md5('1012') | md5('211') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|212') | md5('1012') | md5('212') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1011\|\|112') | md5('1011') | md5('112') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|211') | md5('1012') | md5('211') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|212') | md5('1012') | md5('212') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1011\|\|112') | md5('1011') | md5('111') | 2018-06-01 09:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('112') | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1012\|\|211') | md5('1012') | md5('212') | 2018-06-01 18:00:00.000 | 2018-06-02 09:00:00.000 | 2018-06-02 09:00:00.000 | 2018-06-02 09:00:00.000 | *      |
      | md5('1012\|\|212') | md5('1012') | md5('211') | 2018-06-02 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 09:00:00.000 | 2018-06-02 09:00:00.000 | *      |

  @fixture.enable_auto_end_date
  @fixture.eff_satellite_testing_auto_end_dating
  Scenario: [INCR-LOAD] Incremental load with auto end-dating; CUSTOMER_PK is DFK & ORDER_PK is SFK; 3 loads (with reverting to initial SFKs); one SFK per DFK  
    The changed orders are assigned to either an existing customer or to a new one; then they get reassigned back to the initial customer
    Given the EFF_SAT_CUSTOMER_ORDER table does not exist
# First load...
    And the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
# Second load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
# Third load...
    Given the RAW_STAGE_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_PK | ORDER_PK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
