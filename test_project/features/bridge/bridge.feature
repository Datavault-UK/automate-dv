@fixture.set_workdir
Feature: Bridge

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table with the the AS_OF date and LDTS equal
    Given the BRIDGE_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE          |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                 |
    And the RAW_CUSTOMER_ORDER_PRODUCT table contains data
      | CUSTOMER_ID | ORDER_ID | PRODUCT_ID | LOAD_DATE                  | END_DATE                   | SOURCE |
      | 1001        | 100      | AAA        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1002        | 200      | BBB        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1003        | 300      | CCC        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1004        | 400      | DDD        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-06-01 00:00:00.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE                  | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the BRIDGE_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1001') | 2018-06-01 00:00:00.000000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999999     | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999999    |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999999     | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999999    |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999999     | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999999    |
      | md5('1004') | 2018-06-01 00:00:00.000000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999999     | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999999    |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table with AS_OF dates in the past
    Given the BRIDGE_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE          |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                 |
    And the RAW_CUSTOMER_ORDER_PRODUCT table contains data
      | CUSTOMER_ID | ORDER_ID | PRODUCT_ID | LOAD_DATE                  | END_DATE                   | SOURCE |
      | 1001        | 100      | AAA        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1002        | 200      | BBB        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1003        | 300      | CCC        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1004        | 400      | DDD        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-05-30 00:00:00.000000 |
      | 2018-05-31 00:00:00.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE                  | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the BRIDGE_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |

  @fixture.bridge
  Scenario: [BASE-LOAD] Base load into a bridge table with AS_OF dates in the future and multiple loads in the stage
    Given the BRIDGE_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | LINK                | EFF_SAT                | BRIDGE          |
      | HUB_CUSTOMER | LINK_ORDER_PRODUCT  | EFF_SAT_ORDER_PRODUCT  | BRIDGE_CUSTOMER |
      |              | LINK_CUSTOMER_ORDER | EFF_SAT_CUSTOMER_ORDER |                 |
    And the RAW_CUSTOMER_ORDER_PRODUCT table contains data
      | CUSTOMER_ID | ORDER_ID | PRODUCT_ID | LOAD_DATE                  | END_DATE                   | SOURCE |
      | 1001        | 100      | AAA        | 2018-06-01 00:00:00.000000 | 2018-06-01 23:59:59.999999 | *      |
      | 1001        | 100      | AAA        | 2018-06-02 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1002        | 200      | BBB        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1003        | 300      | CCC        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
      | 1004        | 400      | DDD        | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | *      |
    And I create the STG_CUSTOMER_ORDER_PRODUCT stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2018-06-01 00:00:00.000000 |
      | 2018-06-02 00:00:00.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003') | 1003        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004') | 1004        | 2018-06-01 00:00:00.000000 | *      |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000000 | *      |
    Then the LINK_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | LOAD_DATE                  | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000000 | 2018-06-01 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-02 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-02 00:00:00.000000 | 2018-06-02 00:00:00.000000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_ORDER_PRODUCT table should contain expected data
      | ORDER_PRODUCT_PK  | ORDER_FK   | PRODUCT_FK | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-01 00:00:00.000000 | 2018-06-01 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('100\|\|AAA') | md5('100') | md5('AAA') | 2018-06-02 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-02 00:00:00.000000 | 2018-06-02 00:00:00.000000 | *      |
      | md5('200\|\|BBB') | md5('200') | md5('BBB') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('300\|\|CCC') | md5('300') | md5('CCC') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('400\|\|DDD') | md5('400') | md5('DDD') | 2018-06-01 00:00:00.000000 | 9999-12-31 23:59:59.999999 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the BRIDGE_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | LINK_CUSTOMER_ORDER_PK | EFF_SAT_CUSTOMER_ORDER_ENDDATE | LINK_ORDER_PRODUCT_PK | EFF_SAT_ORDER_PRODUCT_ENDDATE |
      | md5('1002') | 2018-06-01 00:00:00.000000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999999     | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999999    |
      | md5('1003') | 2018-06-01 00:00:00.000000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999999     | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999999    |
      | md5('1004') | 2018-06-01 00:00:00.000000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999999     | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999999    |
      | md5('1001') | 2018-06-02 00:00:00.000000 | md5('1001\|\|100')     | 9999-12-31 23:59:59.999999     | md5('100\|\|AAA')     | 9999-12-31 23:59:59.999999    |
      | md5('1002') | 2018-06-02 00:00:00.000000 | md5('1002\|\|200')     | 9999-12-31 23:59:59.999999     | md5('200\|\|BBB')     | 9999-12-31 23:59:59.999999    |
      | md5('1003') | 2018-06-02 00:00:00.000000 | md5('1003\|\|300')     | 9999-12-31 23:59:59.999999     | md5('300\|\|CCC')     | 9999-12-31 23:59:59.999999    |
      | md5('1004') | 2018-06-02 00:00:00.000000 | md5('1004\|\|400')     | 9999-12-31 23:59:59.999999     | md5('400\|\|DDD')     | 9999-12-31 23:59:59.999999    |
