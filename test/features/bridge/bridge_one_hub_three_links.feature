Feature: [BRG-3L] Bridge table
  Base Bridge behaviour with one hub and three links

  @fixture.bridge
  Scenario: [BRG-3L-01] Base load into a bridge table
  From one hub and three links with the AS_OF date and LDTS equal

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
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
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_PRODUCT_COMPONENT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-01 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK | LINK_PRODUCT_COMPONENT_PK |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     | md5('AAA-0\|\|AAA')       |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-0\|\|BBB')       |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     | md5('CCC-0\|\|CCC')       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |

  @fixture.bridge
  Scenario: [BRG-3L-02] Base load into a bridge table
  From one hub and three links with the AS_OF dates in the past

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
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
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_PRODUCT_COMPONENT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should be empty

  @fixture.bridge
  Scenario: [BRG-3L-03] Base load into a bridge table
  From one hub and three links with the AS_OF dates in the future

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 23:59:59.999 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_PRODUCT_COMPONENT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK | LINK_PRODUCT_COMPONENT_PK |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     | md5('AAA-0\|\|AAA')       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-0\|\|BBB')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     | md5('CCC-0\|\|CCC')       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |

  @fixture.bridge
  Scenario: [BRG-3L-04] Base load into a bridge table
  From one hub and three links with history only in EFF_SAT_ORDER_PRODUCT and encompassing range of AS_OF dates

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
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
      | 300      | CCB        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-2        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCA-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCA-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCB-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCB-1        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCB-2        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_PRODUCT_COMPONENT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK | LINK_PRODUCT_COMPONENT_PK |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-0\|\|BBB')       |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     | md5('AAA-0\|\|AAA')       |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-0\|\|AAB')       |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-0\|\|AAAA')      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-0\|\|BBB')       |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     | md5('AAA-0\|\|AAA')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-0\|\|AAB')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-0\|\|AAAA')      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-0\|\|BBB')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCB')     | md5('CCB-0\|\|CCB')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCB')     | md5('CCB-1\|\|CCB')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCB')     | md5('CCB-2\|\|CCB')       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |

  @fixture.bridge
  Scenario: [BRG-3L-05] Base load into a bridge table
  From one hub and three links with history only in EFF_SAT_PRODUCT_COMPONENT and encompassing range of AS_OF dates

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAA        | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | AAB        | AAB-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAB       | AAA-2        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-3        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | BBB        | BBB-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-3        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_PRODUCT_COMPONENT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK | LINK_PRODUCT_COMPONENT_PK |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAB')    | md5('AAA-0\|\|AAAB')      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAB')    | md5('AAA-1\|\|AAAB')      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAB')    | md5('AAA-3\|\|AAAB')      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-2\|\|BBB')       |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-3\|\|BBB')       |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     | md5('AAA-1\|\|AAA')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-1\|\|AAB')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-2\|\|AAB')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAB')    | md5('AAA-0\|\|AAAB')      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAB')    | md5('AAA-1\|\|AAAB')      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAB')    | md5('AAA-3\|\|AAAB')      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-2\|\|BBB')       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-3\|\|BBB')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     | md5('CCC-0\|\|CCC')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     | md5('CCC-1\|\|CCC')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCC')     | md5('CCC-2\|\|CCC')       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |

  @fixture.bridge
  Scenario: [BRG-3L-06] Base load into a bridge table
  From one hub and three links with history in EFF_SAT_ORDER_PRODUCT and EFF_SAT_PRODUCT_COMPONENT, and encompassing range of AS_OF dates

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                  |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                         |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                         |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCB        | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | 300      | CCB        | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAA        | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | AAB        | AAB-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-2        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-0        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-3        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | BBB        | BBB-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-3        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | CCA        | CCC-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCC-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | CCB        | CCC-1        | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | CCB        | CCC-0        | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_PRODUCT_COMPONENT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK | LINK_PRODUCT_COMPONENT_PK |
      | md5('1004') | 2018-06-01 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-2\|\|BBB')       |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-3\|\|BBB')       |
      | md5('1004') | 2018-06-01 12:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAA')     | md5('AAA-1\|\|AAA')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-1\|\|AAB')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-2\|\|AAB')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-2\|\|BBB')       |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-3\|\|BBB')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003\|\|300')     | md5('300\|\|CCB')     | md5('CCC-0\|\|CCB')       |
      | md5('1004') | 2018-06-02 00:00:00.000 | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |

  @skip
  @fixture.bridge
  Scenario: [BRG-3L-07] Base load into a bridge table with additional columns
  From one hub and three links with history in EFF_SAT_ORDER_PRODUCT and EFF_SAT_PRODUCT_COMPONENT, and encompassing range of AS_OF dates

    Given the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT_AC table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                   | EFF_SAT                   | BRIDGE                                     |
      | HUB_CUSTOMER | LINK_PRODUCT_COMPONENT | EFF_SAT_PRODUCT_COMPONENT | BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT_AC |
      |              | LINK_ORDER_PRODUCT     | EFF_SAT_ORDER_PRODUCT     |                                            |
      |              | LINK_CUSTOMER_ORDER    | EFF_SAT_CUSTOMER_ORDER    |                                            |
    And the RAW_CUSTOMER_ORDER table contains data
      | CUSTOMER_ID | ORDER_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 1001        | 100      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1001        | 100      | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1001        | 101      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1002        | 200      | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | 1003        | 300      | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | 1004        | 400      | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_ORDER data
    And the RAW_ORDER_PRODUCT table contains data
      | ORDER_ID | PRODUCT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | 100      | AAA        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 100      | AAA        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 100      | AAB        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAB       | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 101      | AAAA       | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 200      | BBB        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | 300      | CCC        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 09:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | 300      | CCA        | 2018-06-01 12:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | 300      | CCB        | 2018-06-01 18:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | 300      | CCB        | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | 400      | DDD        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_ORDER_PRODUCT data
    And the RAW_PRODUCT_COMPONENT table contains data
      | PRODUCT_ID | COMPONENT_ID | LOAD_DATETIME           | END_DATE                | SOURCE |
      | AAA        | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAA        | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | AAB        | AAB-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAB        | AAB-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAA       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | AAAA       | AAA-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-0        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-1        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-2        | 2018-06-01 00:00:00.000 | 2018-06-01 12:00:00.000 | *      |
      | AAAB       | AAA-0        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-1        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | AAAB       | AAA-3        | 2018-06-01 12:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-0        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 00:00:00.000 | 2018-06-01 05:59:59.999 | *      |
      | BBB        | BBB-1        | 2018-06-01 06:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | BBB        | BBB-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | BBB        | BBB-3        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 08:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 09:00:00.000 | 2018-06-01 17:59:59.999 | *      |
      | CCC        | CCC-0        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-1        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCC        | CCC-2        | 2018-06-01 18:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 11:59:59.999 | *      |
      | CCA        | CCC-1        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCA        | CCC-2        | 2018-06-01 12:00:00.000 | 9999-12-31 23:59:59.999 | *      |
      | CCB        | CCC-0        | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | CCB        | CCC-1        | 2018-06-01 00:00:00.000 | 2018-06-01 18:00:00.000 | *      |
      | CCB        | CCC-0        | 2018-06-01 18:00:00.001 | 9999-12-31 23:59:59.999 | *      |
      | DDD        | DDD-0        | 2018-06-01 00:00:00.000 | 9999-12-31 23:59:59.999 | *      |
    And I stage the STG_PRODUCT_COMPONENT data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 00:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
    When I load the vault
    Then the BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT_AC table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | CUSTOMER_ID | LINK_CUSTOMER_ORDER_PK | LINK_ORDER_PRODUCT_PK | LINK_PRODUCT_COMPONENT_PK |
      | md5('1004') | 2018-06-01 00:00:00.000 | 1004        | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-01 12:00:00.000 | 1001        | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1002') | 2018-06-01 12:00:00.000 | 1002        | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-2\|\|BBB')       |
      | md5('1002') | 2018-06-01 12:00:00.000 | 1002        | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-3\|\|BBB')       |
      | md5('1004') | 2018-06-01 12:00:00.000 | 1004        | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|100')     | md5('100\|\|AAA')     | md5('AAA-1\|\|AAA')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-1\|\|AAB')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|100')     | md5('100\|\|AAB')     | md5('AAB-2\|\|AAB')       |
      | md5('1001') | 2018-06-02 00:00:00.000 | 1001        | md5('1001\|\|101')     | md5('101\|\|AAAA')    | md5('AAA-1\|\|AAAA')      |
      | md5('1002') | 2018-06-02 00:00:00.000 | 1002        | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-2\|\|BBB')       |
      | md5('1002') | 2018-06-02 00:00:00.000 | 1002        | md5('1002\|\|200')     | md5('200\|\|BBB')     | md5('BBB-3\|\|BBB')       |
      | md5('1003') | 2018-06-02 00:00:00.000 | 1003        | md5('1003\|\|300')     | md5('300\|\|CCB')     | md5('CCC-0\|\|CCB')       |
      | md5('1004') | 2018-06-02 00:00:00.000 | 1004        | md5('1004\|\|400')     | md5('400\|\|DDD')     | md5('DDD-0\|\|DDD')       |
