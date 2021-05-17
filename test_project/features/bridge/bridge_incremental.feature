@fixture.set_workdir
Feature: Bridge

  ####################### INCREMENTAL LOAD #######################

# ------------------------ ONE LINK ------------------------

  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates and an updated order into an already populated bridge table from one hub and one link
    This tests whether the bridge macro responds correctly to changing end dates of existing bridge records
    NOTE that this is an artificial example in that there is actually nothing to trigger the creation of the new EFF_SAT_CUSTOMER_ORDER record for customer 1001
    Hence during the second load the raw vault tables have to be 'manually' loaded with records
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
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
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
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
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
    And the HUB_CUSTOMER table is created and populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
#    Then the LINK_CUSTOMER_ORDER table should contain expected data
    And the LINK_CUSTOMER_ORDER table is created and populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
#    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
    And the EFF_SAT_CUSTOMER_ORDER table is created and populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
    When I load the BRIDGE_CUSTOMER_ORDER bridge
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates and a new order into an already populated bridge table from one hub and one link
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
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
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
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
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        |

# ------------------------ TWO LINKs ------------------------

  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates and updated records into an already populated bridge table from one hub and two links
    This tests whether the bridge macro responds correctly to changing end dates of existing bridge records
    NOTE that this is an artificial example in that there is actually nothing to trigger the creation of the new EFF_SAT_CUSTOMER_ORDER record for customer 1001
    Hence during the second load the raw vault tables have to be 'manually' loaded with records
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
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
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
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
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
#    When I load the vault
#    Then the HUB_CUSTOMER table should contain expected data
    And the HUB_CUSTOMER table is created and populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
#    Then the LINK_CUSTOMER_ORDER table should contain expected data
    And the LINK_CUSTOMER_ORDER table is created and populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
#    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
    And the EFF_SAT_CUSTOMER_ORDER table is created and populated with data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
#    Then the LINK_ORDER_PRODUCT table should contain expected data
    And the LINK_ORDER_PRODUCT table is created and populated with data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB') | md5('100') | md5('AAB') | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
#    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
    And the EFF_SAT_ORDER_PRODUCT table is created and populated with data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('100\|\|AAB') | md5('100') | md5('AAB') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
  #    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
    When I load the BRIDGE_CUSTOMER_ORDER_PRODUCT bridge
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAB')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |

  @fixture.bridge
  Scenario: [INCR-LOAD] Incremental load with the more recent AS OF dates and new records into an already populated bridge table from one hub and two links
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
# First load...
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
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
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
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
      | CUSTOMER_ID | ORDER_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_CUSTOMER_ORDER stage
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATE               | END_DATE                | SOURCE |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I create the STG_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE               | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1001\|\|101') | md5('1001') | md5('101') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK   | ORDER_FK   | PRODUCT_FK  | START_DATE              | END_DATE                | EFFECTIVE_FROM          | LOAD_DATE               | SOURCE |
      | md5('100\|\|AAA')  | md5('100') | md5('AAA')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('101\|\|AAAA') | md5('101') | md5('AAAA') | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 12:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | md5('200\|\|BBB')  | md5('200') | md5('BBB')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('300\|\|CCC')  | md5('300') | md5('CCC')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('400\|\|DDD')  | md5('400') | md5('DDD')  | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999        | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | 9999-12-31 23:59:59.999        | md5('101\|\|AAAA')    | 9999-12-31 23:59:59.999       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999        | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999        | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999        | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999       |
    