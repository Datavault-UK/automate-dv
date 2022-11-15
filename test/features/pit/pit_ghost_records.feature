Feature: [PIT-GR] Point in Time With Ghost Rcords

@fixture.pit
@fixture.enable_ghost_records
  Scenario: [PIT-GR-01] Load into a pit table where the AS OF table is already established with increments of a day
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE          |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | DBTVAULT_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *               |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *               |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *               |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE          |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | DBTVAULT_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *               |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *               |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *               |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *               |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *               |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *               |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE          |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | DBTVAULT_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *               |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *               |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *               |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *               |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *               |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *               |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK                      | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK          | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK          | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1002')                      | 2019-01-02 00:00:00.000000 | md5('1002')                      | 2018-12-01 00:00:00.000000 | md5('1002')                      | 2019-01-02 00:00:00.000000 | md5('1002')                      | 2019-01-02 00:00:00.000000 |
      | md5('1002')                      | 2019-01-03 00:00:00.000000 | md5('1002')                      | 2018-12-01 00:00:00.000000 | md5('1002')                      | 2019-01-03 00:00:00.000000 | md5('1002')                      | 2019-01-03 00:00:00.000000 |
      | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2018-12-01 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 |
      | md5('1001')                      | 2019-01-02 00:00:00.000000 | md5('1001')                      | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-02 00:00:00.000000 | md5('1001')                      | 2019-01-02 00:00:00.000000 |
      | md5('1001')                      | 2019-01-03 00:00:00.000000 | md5('1001')                      | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 |
      | md5('1001')                      | 2019-01-04 00:00:00.000000 | md5('1001')                      | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-04 00:00:00.000000 | md5('1001')                      | 2019-01-04 00:00:00.000000 |