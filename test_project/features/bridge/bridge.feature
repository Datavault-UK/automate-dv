@fixture.set_workdir
Feature: Bridge

  @fixture.bridge
  Scenario: Load into a bridge table where the AS_OF table is already established and the AS_OF table has increments of a day
    Given the BRIDGE table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS                | EFF_SATS                | BRIDGE          |
      | HUB_CUSTOMER | LINK_CUSTOMER_NATION | EFF_SAT_CUSTOMER_NATION | BRIDGE_CUSTOMER |
      |              | LINK_CUSTOMER_ORDER  | EFF_SAT_CUSTOMER_ORDER  |                 |
    And the RAW_CUSTOMER_ORDER_NATION table contains data
      | CUSTOMER_ID | ORDER_ID | NATION_ID  | LOAD_DATE                  | SOURCE |
      | 1001        | 100      | GBR        | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | 200      | POL        | 2018-06-01 00:00:00.000000 | *      |
      | 1003        | 300      | DEU        | 2018-06-01 00:00:00.000000 | *      |
      | 1004        | 400      | ITA        | 2018-06-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_ORDER_NATION stage
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
    Then the LINK_CUSTOMER_NATION table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|DEU') | md5('1003') | md5('DEU') | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|ITA') | md5('1004') | md5('ITA') | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|300') | md5('1003') | md5('300') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|400') | md5('1004') | md5('400') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the EFF_SAT_CUSTOMER_NATION table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | START_DATE                 | END_DATE                   | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1003\|\|DEU') | md5('1003') | md5('DEU') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1004\|\|ITA') | md5('1004') | md5('ITA') | 2018-06-01 00:00:00.000000 | 9999-12-31 00:00:00.000000 | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
    Then the BRIDGE_CUSTOMER table should contain expected data
      | CUSTOMER_PK  | AS_OF_DATE                 | LINK_CUSTOMER_ORDER_PK | LINK_CUSTOMER_NATION_PK | EFF_SAT_CUSTOMER_ORDER_END_DATE | EFF_SAT_CUSTOMER_ORDER_END_DATE |
      | md5('1001')  | 2018-06-01 00:00:00.000000 | md5('1001\|\|100')     | md5('1001\|\|GBR')      | 9999-12-31 00:00:00.000000      | 9999-12-31 00:00:00.000000      |
      | md5('1002')  | 2018-06-01 00:00:00.000000 | md5('1002\|\|200')     | md5('1002\|\|POL')      | 9999-12-31 00:00:00.000000      | 9999-12-31 00:00:00.000000      |
      | md5('1003')  | 2018-06-01 00:00:00.000000 | md5('1003\|\|300')     | md5('1003\|\|DEU')      | 9999-12-31 00:00:00.000000      | 9999-12-31 00:00:00.000000      |
      | md5('1004')  | 2018-06-01 00:00:00.000000 | md5('1004\|\|400')     | md5('1004\|\|ITA')      | 9999-12-31 00:00:00.000000      | 9999-12-31 00:00:00.000000      |