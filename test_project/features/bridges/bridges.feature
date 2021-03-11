@fixture.set_workdir
Feature: Bridge

  @fixture.bridge
  Scenario: Load into a pit table where the AS IS table is already established and the AS_IS table has increments of a day
    Given the BRIDGE table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                 | T_LINKS | EFF_SATS | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS |         |          | PIT_CUSTOMER |
      |              |       | SAT_CUSTOMER_LOGIN   |         |          |              |
      |              |       | SAT_CUSTOMER_PROFILE |         |          |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_DETAILS stage
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_LOGIN stage
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *      |
    And I create the STG_CUSTOMER_PROFILE stage
    And the AS_OF_DATE table contains data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    And I create the AS_OF_DATE as of date table
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE                  | SOURCE |
      | md5('1001') | 1001        | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | 1002        | 2018-06-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 3 Forrest road Hampshire | 2006-04-17   | md5('3 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-12-01 00:00:00.000000 | 2018-12-01 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE            | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | 2019-01-01 02:00:00.000000 | Phone       | md5('PHONE\|\|2019-01-01 02:00:00.000')  | 2019-01-02 00:00:00.000000 | 2019-01-02 00:00:00.000000 | *      |
      | md5('1001') | 2019-01-02 03:00:00.000000 | Phone       | md5('PHONE\|\|2019-01-02 03:00:00.000')  | 2019-01-03 00:00:00.000000 | 2019-01-03 00:00:00.000000 | *      |
      | md5('1001') | 2019-01-03 01:00:00.000000 | Laptop      | md5('LAPTOP\|\|2019-01-03 01:00:00.000')  | 2019-01-04 00:00:00.000000 | 2019-01-04 00:00:00.000000 | *      |
      | md5('1002') | 2019-01-01 05:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-01 05:00:00.000') | 2019-01-02 00:00:00.000000 | 2019-01-02 00:00:00.000000 | *      |
      | md5('1002') | 2019-01-02 06:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-02 06:00:00.000') | 2019-01-03 00:00:00.000000 | 2019-01-03 00:00:00.000000 | *      |
      | md5('1002') | 2019-01-03 08:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-03 08:00:00.000') | 2019-01-04 00:00:00.000000 | 2019-01-04 00:00:00.000000 | *      |
    Then the SAT_CUSTOMER_PROFILE table should contain expected data
      | CUSTOMER_PK | DASHBOARD_COLOUR | DISPLAY_NAME | HASHDIFF              | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | red              | ab12         | md5('RED\|\|AB12')    | 2019-01-02 00:00:00.000000 | 2019-01-02 00:00:00.000000 | *      |
      | md5('1001') | blue             | ab12         | md5('BLUE\|\|AB12') ) | 2019-01-03 00:00:00.000000 | 2019-01-03 00:00:00.000000 | *      |
      | md5('1001') | brown            | ab12         | md5('BROWN\|\|AB12')  | 2019-01-04 00:00:00.000000 | 2019-01-04 00:00:00.000000 | *      |
      | md5('1002') | yellow           | cd34         | md5('YELLOW\|\|CD34') | 2019-01-02 00:00:00.000000 | 2019-01-02 00:00:00.000000 | *      |
      | md5('1002') | yellow           | ef56         | md5('YELLOW\|\|EF56') | 2019-01-03 00:00:00.000000 | 2019-01-03 00:00:00.000000 | *      |
      | md5('1002') | pink             | ef56         | md5('PINK\|\|EF56')   | 2019-01-04 00:00:00.000000 | 2019-01-04 00:00:00.000000 | *      |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-02 00:00:00.000000 | md5('1002')             | 2019-01-02 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-02 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
