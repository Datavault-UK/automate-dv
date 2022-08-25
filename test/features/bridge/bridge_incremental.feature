Feature: [BRG] Bridge table
  Incremental Bridge behaviour with one hub and one/two links

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [BRG-01] Bridge on one hub and one link
  Incremental load with auto end-dating with more recent AS OF dates and new orders
  New order or changed order are assigned only to existing customers

    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [BRG-02] Bridge on one hub and one link
  Incremental load with auto end-dating with new AS OF dates in the past
  Should return an empty BRIDGE table after the 2nd load; then should build a proper bridge again after 3rd load

    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-30 00:00:00.000 |
      | 2018-05-30 12:00:00.000 |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | LINK_CUSTOMER_ORDER_PK |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [BRG-03] Bridge on one hub and one link
  Incremental load with auto end-dating with more recent AS OF dates and new/changed orders
  New orders or changed orders are assigned to existing customers, as well as to new ones

    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 111      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|101')     |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     |
      | md5('1011') | 2018-06-01 12:00:00.000 | md5('1011\|\|111')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     |
      | md5('1011') | 2018-06-01 18:00:00.000 | md5('1011\|\|111')     |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     |
      | md5('1011') | 2018-06-02 00:00:00.000 | md5('1011\|\|111')     |
      | md5('1012') | 2018-06-02 00:00:00.000 | md5('1012\|\|200')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [BRG-04] Bridge on one hub and one link
  Incremental load with auto end-dating with more recent AS OF dates and changed orders
  The changed orders are assigned to either an existing customer or to a new one; then they get reassigned back to the initial customer

    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|100')     |
      | md5('1012') | 2018-06-01 09:00:00.000 | md5('1012\|\|200')     |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     |
      | md5('1012') | 2018-06-02 00:00:00.000 | md5('1012\|\|200')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 09:00:00.001 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-01 18:00:00.001 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|100')     |
      | md5('1012') | 2018-06-01 09:00:00.000 | md5('1012\|\|200')     |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     |
      | md5('1002') | 2018-06-01 09:00:00.001 | md5('1002\|\|100')     |
      | md5('1012') | 2018-06-01 09:00:00.001 | md5('1012\|\|200')     |
      | md5('1003') | 2018-06-01 09:00:00.001 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 09:00:00.001 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-01 18:00:00.001 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 18:00:00.001 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 18:00:00.001 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 18:00:00.001 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [BRG-05] Bridge on one hub and two links
  Incremental load with auto end-dating with more recent AS OF dates and new/changed orders
  New orders or changed orders are assigned to existing customers, as well as to new ones
  New orders or changed orders get assigned existing or new products

    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1011        | 111      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAB        | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAA        | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 111      | ABB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDDA       | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDDB       | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAA')     |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAA')     |
      | md5('1011') | 2018-06-01 12:00:00.000 | md5('1011\|\|111')     | md5('111\|\|ABB')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1001') | 2018-06-01 18:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAA')     |
      | md5('1011') | 2018-06-01 18:00:00.000 | md5('1011\|\|111')     | md5('111\|\|ABB')     |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCA')     |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDDA')    |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDDB')    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAA')     |
      | md5('1011') | 2018-06-02 00:00:00.000 | md5('1011\|\|111')     | md5('111\|\|ABB')     |
      | md5('1012') | 2018-06-02 00:00:00.000 | md5('1012\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCA')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDDA')    |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDDB')    |

  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [BRG-06] Bridge on one hub and two links
  Incremental load with auto end-dating and more recent AS OF dates.
  An existing order gets assigned either to another existing customer or to a new customer,
  it gets reassigned to the initial customer

    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1012        | 200      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAB        | 2018-06-01 09:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBBB       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDDA       | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBBB')    |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | md5('200\|\|BBBB')    |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCA')     |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDDA')    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1012') | 2018-06-02 00:00:00.000 | md5('1012\|\|200')     | md5('200\|\|BBBB')    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCA')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDDA')    |
    Given the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 09:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-01 18:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1001') | 2018-06-01 09:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     |
      | md5('1002') | 2018-06-01 09:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 09:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 09:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBBB')    |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1002') | 2018-06-01 18:00:00.000 | md5('1002\|\|100')     | md5('100\|\|AAB')     |
      | md5('1012') | 2018-06-01 18:00:00.000 | md5('1012\|\|200')     | md5('200\|\|BBBB')    |
      | md5('1003') | 2018-06-01 18:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCA')     |
      | md5('1004') | 2018-06-01 18:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDDA')    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |

  @skip
  @fixture.enable_auto_end_date
  @fixture.bridge
  Scenario: [BRG-07] Bridge on one hub and one link and additional columns
  Incremental load with auto end-dating with more recent AS OF dates and new orders
  New order or changed order are assigned only to existing customers

    Given the BRIDGE_CUSTOMER_ORDER_AC table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                   |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER_AC |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    And I load the vault
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_AC table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | CUSTOMER_ID | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | 1001        | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | 1002        | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | 1003        | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | 1004        | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-01 12:00:00.000 | 1001        | md5('1001\|\|101')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | 1002        | md5('1002\|\|100')     |
      | md5('1002') | 2018-06-01 12:00:00.000 | 1002        | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 12:00:00.000 | 1003        | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-01 12:00:00.000 | 1004        | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|101')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | 1002        | md5('1002\|\|100')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | 1002        | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | 1003        | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | 1004        | md5('1004\|\|400')     |
