@fixture.set_workdir
Feature: Bridge

  # TODO: tests hasve correct bridge data, but it needs new bridge macro
  #  (and new eff_sat data and macro - LINE 106 - to sort out the issue with the overlap between the previous relationship's END_DATE and the new relationship's START_DATE)

  # TODO: eff sat fix the timestamp of the old record END_DATE (so that it is not overlapping with the new record START_DATE)?
  # eff sat auto end dating in client systems is enabled by default
  # eff sat auto end dating in the test framework is NOT enabled by default and has to be enabled if required
  # the bridge macro SQL requires eff sat auto end dating to be enabled

  ####################### INCREMENTAL LOAD #######################

# ------------------------ ONE LINK ------------------------

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with auto end-dating with more recent AS OF dates and a new order & a change of customer into an already populated bridge table from one hub and one link
    New order or changed order are assigned only to existing customers
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
# Second load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with auto end-dating with new AS OF dates in the past; bridge table is already populated with data from one hub and one link
    Should return an empty BRIDGE table after the 2nd load; then should build a proper bridge again after 3rd load
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
# Second load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-30 00:00:00.000 |
      | 2018-05-30 12:00:00.000 |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
# Third load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 18:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with auto end-dating with more recent AS OF dates and two new orders + two changed orders into an already populated bridge table from one hub and one link
    New orders or changed orders are assigned to existing customers, as well as to new ones
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
# Second load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 111      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
#    When I load the vault
    When I load the HUB_CUSTOMER hub
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
      | md5('1011') | 1011        | 2018-06-01 12:00:00.000 | *      |
      | md5('1012') | 1012        | 2018-06-01 18:00:00.000 | *      |
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 12:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
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
    When I load the BRIDGE_CUSTOMER_ORDER bridge
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1011') | 2018-06-01 12:00:00.000 | md5('1011\|\|111')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1011') | 2018-06-01 18:00:00.000 | md5('1011\|\|111')     | 9999-12-31 23:59:59.999        |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1011') | 2018-06-01 18:00:00.000 | md5('1011\|\|111')     | 9999-12-31 23:59:59.999        |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with auto end-dating with more recent AS OF dates and two changed orders into an already populated bridge table from one hub and one link
    The changed orders are assigned to either an existing customer or to a new one; then they get reassigned back to the initial customer
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
# Second load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
      | md5('1012') | 1012        | 2018-06-01 09:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1012') | 2018-06-01 09:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1012') | 2018-06-02 00:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
# Third load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 09:00:00.001 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-01 18:00:00.001 |
      | 2018-06-02 00:00:00.000 |
#    When I load the vault
    When I load the HUB_CUSTOMER hub
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
      | md5('1012') | 1012        | 2018-06-01 09:00:00.000 | *      |
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 09:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 09:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
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
    When I load the BRIDGE_CUSTOMER_ORDER bridge
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1002') | 2018-06-01 09:00:00.001 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 09:00:00.001 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 09:00:00.001 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 09:00:00.001 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1001') | 2018-06-01 18:00:00.001 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 18:00:00.001 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 18:00:00.001 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 18:00:00.001 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

# ------------------------ TWO LINKS ------------------------

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with auto end-dating with more recent AS OF dates and two new orders + two changed orders into an already populated bridge table from one hub and two links
    New orders or changed orders are assigned to existing customers, as well as to new ones
    New orders or changed orders get assigned existing or new products
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |
# Second load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 111      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAB        | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAA        | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 111      | ABB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDDA       | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDDB       | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
#    When I load the vault
    When I load the HUB_CUSTOMER hub
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
      | md5('1011') | 1011        | 2018-06-01 12:00:00.000 | *      |
      | md5('1012') | 1012        | 2018-06-01 18:00:00.000 | *      |
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 09:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | *      |
      | md5('1011\|\|111') | md5('1011') | md5('111') | 2018-06-01 12:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
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
    When I load the LINK_ORDER_PRODUCT link
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 09:00:00.000 | *      |
      | md5('101\|\|AAA')  | md5('101') | md5('AAA')  | 2018-06-01 09:00:00.000 | *      |
      | md5('111\|\|ABB')  | md5('111') | md5('ABB')  | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDA') | md5('400') | md5('DDDA') | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDB') | md5('400') | md5('DDDB') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_PRODUCT eff_sat
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('101\|\|AAA')  | md5('101') | md5('AAA')  | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('111\|\|ABB')  | md5('111') | md5('ABB')  | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDA') | md5('400') | md5('DDDA') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDB') | md5('400') | md5('DDDB') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
    When I load the BRIDGE_CUSTOMER_ORDER_PRODUCT bridge
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1011') | 2018-06-01 12:00:00.000 | md5('1011\|\|111')     | 9999-12-31 23:59:59.999        | md5('111\|\|ABB')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1011') | 2018-06-01 18:00:00.000 | md5('1011\|\|111')     | 9999-12-31 23:59:59.999        | md5('111\|\|ABB')     | 9999-12-31 23:59:59.999       |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCA')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDA')    | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDB')    | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1011') | 2018-06-02 00:00:00.000 | md5('1011\|\|111')     | 9999-12-31 23:59:59.999        | md5('111\|\|ABB')     | 9999-12-31 23:59:59.999       |
      | md5('1012') | 2018-06-02 00:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCA')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDA')    | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDB')    | 9999-12-31 23:59:59.999       |

  # TODO: test not passing; check data in target tables (ORDER_PRODUCT) after 2nd load
  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with auto end-dating and more recent AS OF dates into an already populated bridge table from one hub and two links
    An existing order gets assigned either to another existing customer or to a new customer, then it gets reassigned to the initial customer
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
# Second load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBBB       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDDA       | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDDB       | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
#    When I load the HUB_CUSTOMER hub
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
      | md5('1012') | 1012        | 2018-06-01 18:00:00.000 | *      |
#    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | *      |
#    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#    When I load the LINK_ORDER_PRODUCT link
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 09:00:00.000 | *      |
      | md5('200\|\|BBBB') | md5('200') | md5('BBBB') | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDA') | md5('400') | md5('DDDA') | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDB') | md5('400') | md5('DDDB') | 2018-06-01 18:00:00.000 | *      |
#    When I load the EFF_SAT_ORDER_PRODUCT eff_sat
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBBB') | md5('200') | md5('BBBB') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDA') | md5('400') | md5('DDDA') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDB') | md5('400') | md5('DDDB') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
#    When I load the BRIDGE_CUSTOMER_ORDER_PRODUCT bridge
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBBB')    | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBBB')    | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCA')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDA')    | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDB')    | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1012') | 2018-06-02 00:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBBB')    | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCA')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDA')    | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDB')    | 9999-12-31 23:59:59.999       |

# Third load...
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
#    When I load the vault
    When I load the HUB_CUSTOMER hub
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
      | md5('1012') | 1012        | 2018-06-01 18:00:00.000 | *      |
    When I load the LINK_CUSTOMER_ORDER link
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_CUSTOMER_ORDER eff_sat
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('1002\|\|100') | md5('1002') | md5('100') | 2018-06-01 12:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1012\|\|200') | md5('1012') | md5('200') | 2018-06-01 18:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
    When I load the LINK_ORDER_PRODUCT link
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 09:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDA') | md5('400') | md5('DDDA') | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDB') | md5('400') | md5('DDDB') | 2018-06-01 18:00:00.000 | *      |
    When I load the EFF_SAT_ORDER_PRODUCT eff_sat
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 09:00:00.000 | 2018-06-01 09:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBBB') | md5('200') | md5('BBBB') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDA') | md5('400') | md5('DDDA') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('400\|\|DDDB') | md5('400') | md5('DDDB') | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | md5('100\|\|AAB')  | md5('100') | md5('AAB')  | 2018-06-01 09:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('200\|\|BBBB') | md5('200') | md5('BBBB') | 2018-06-01 12:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('300\|\|CCA')  | md5('300') | md5('CCA')  | 2018-06-01 18:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('400\|\|DDDA') | md5('400') | md5('DDDA') | 2018-06-01 18:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('400\|\|DDDB') | md5('400') | md5('DDDB') | 2018-06-01 18:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
    When I load the BRIDGE_CUSTOMER_ORDER_PRODUCT bridge
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBBB')    | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBBB')    | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCA')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDA')    | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDDB')    | 9999-12-31 23:59:59.999       |

      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |


