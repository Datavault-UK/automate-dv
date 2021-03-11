@fixture.set_workdir
Feature: Bridge

  @fixture.bridge
  Scenario: Load into a bridge table where the AS IS table is already established and the AS_IS table has increments of a day
    Given the BRIDGE table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS                | EFF_SATS                | BRIDGE          |
      | HUB_CUSTOMER | LINK_CUSTOMER_NATION | EFF_SAT_CUSTOMER_NATION | BRIDGE_CUSTOMER |
      |              | LINK_CUSTOMER_ORDER  | EFF_SAT_CUSTOMER_ORDER  |                 |
    And the RAW_ORDERS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *      |
    And I create the STG_ORDERS stage
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
    Then the LINK_CUSTOMER_NATION table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    Then the LINK_CUSTOMER_ORDER table should contain expected data
      | CUSTOMER_ORDER_PK  | CUSTOMER_FK | ORDER_FK   | LOAD_DATE  | SOURCE |
      | md5('1001\|\|100') | md5('1001') | md5('100') | 1993-01-01 | CRM    |
      | md5('1002\|\|200') | md5('1002') | md5('200') | 1993-01-01 | CRM    |
      | md5('1004\|\|300') | md5('1004') | md5('300') | 1993-01-01 | CRM    |
      | md5('1005\|\|400') | md5('1005') | md5('400') | 1993-01-01 | CRM    |
    Then the EFF_SAT_CUSTOMER_NATION table should contain expected data
    Then the EFF_SAT_CUSTOMER_ORDER table should contain expected data
    Then the BRIDGE_CUSTOMER table should contain expected data
