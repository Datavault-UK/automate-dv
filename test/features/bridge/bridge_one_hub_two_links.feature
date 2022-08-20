Feature: [BRG-2L] Bridge table
  Base Bridge behaviour with one hub and two links

  @fixture.bridge
  Scenario: [BRG-2L-01] Base load into a bridge table
  From one hub and two links with the AS_OF date and LDTS equal

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
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

  @fixture.bridge
  Scenario: [BRG-2L-02] Base load into a bridge table
  From one hub and two links with AS_OF dates in the past

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
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
      | 2018-05-30 00:00:00.000 |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should be empty

  @fixture.bridge
  Scenario: [BRG-2L-03] Base load into a bridge table
  From one hub and two links with AS_OF dates in the future

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
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
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |

  @fixture.bridge
  Scenario: [BRG-2L-04] Base load into a bridge table
  From one hub and two links with multiple loads and an encompassing range of AS_OF dates

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAB')    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |

  @fixture.bridge
  Scenario: [BRG-2L-05] Base load into a bridge table
  From one hub and two links with history and encompassing range of AS_OF dates

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                        |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                               |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     |

  @skip
  @fixture.bridge
  Scenario: [BRG-2L-06] Base load into a bridge table with additional columns
  From one hub and two links with history and encompassing range of AS_OF dates

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_AC table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE                           |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER_ORDER_PRODUCT_AC |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                                  |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_AC table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | CUSTOMER_ID | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK |
      | md5('1002') | 2018-06-01 00:00:00.000 | 1002        | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1004') | 2018-06-01 00:00:00.000 | 1004        | md5('1004\|\|400')     | md5('400\|\|DDD')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|100')     | md5('100\|\|AAA')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|100')     | md5('100\|\|AAB')     |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|101')     | md5('101\|\|AAAA')    |
      | md5('1002') | 2018-06-02 00:00:00.000 | 1002        | md5('1002\|\|200')     | md5('200\|\|BBB')     |
      | md5('1003') | 2018-06-02 00:00:00.000 | 1003        | md5('1003\|\|300')     | md5('300\|\|CCC')     |
      | md5('1004') | 2018-06-02 00:00:00.000 | 1004        | md5('1004\|\|400')     | md5('400\|\|DDD')     |
