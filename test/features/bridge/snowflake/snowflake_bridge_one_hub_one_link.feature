Feature: [SF-BRG-1L] Bridge table
  Base Bridge behaviour with one hub and one link

  @fixture.bridge
  Scenario: [SF-BRG-1L-001] Base load into a bridge table from one hub and one link with the AS_OF date and LDTS equal
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

  @fixture.bridge
  Scenario: [SF-BRG-1L-002] Base load into a bridge table from one hub and one link with AS_OF dates in the past
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-02 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-30 00:00:00.000 |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should be empty

  @fixture.bridge
  Scenario: [SF-BRG-1L-003] Base load into a bridge table from one hub and one link with AS_OF dates in the future
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-02 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-02 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-03 00:00:00.000 |
      | 2018-06-04 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-03 00:00:00.000 | md5('1004\|\|400')     |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1004') | 2018-06-04 00:00:00.000 | md5('1004\|\|400')     |

  @fixture.bridge
  Scenario: [SF-BRG-1L-004] Base load into a bridge table from one hub and one link with multiple loads and an encompassing range of AS OF dates
    Given the BRIDGE_CUSTOMER_ORDER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                |
      | HUB_CUSTOMER | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER | BRIDGE_CUSTOMER_ORDER |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 201      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 301      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|201')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|301')     |