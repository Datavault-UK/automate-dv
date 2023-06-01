Feature: [PIT-GR] Point in Time with Ghost Records

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-01] Load into a pit table where the AS OF table is already established with increments of a day with ghost records enabled
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-02 00:00:00.000000 | md5('1002')             | 2019-01-02 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-02 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-02] Load into a pit table where the AS OF table is already established but the final pit table will deal with NULL Values as ghost records
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-02 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | md5('1002')             | 2019-01-02 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-03] Load into a pit table where the AS OF table is already established and the AS OF table has increments of 30 mins and ghost records
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE           | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 10:01:00.000000 | Phone       | 2019-01-01 10:15:00 | *                  |
      | 1001        | 2019-01-01 10:36:00.000000 | Phone       | 2019-01-01 10:45:00 | *                  |
      | 1001        | 2019-01-01 10:56:00.000000 | Laptop      | 2019-01-01 11:15:00 | *                  |
      | 1002        | 2019-01-01 09:55:00.000000 | Tablet      | 2019-01-01 10:15:00 | *                  |
      | 1002        | 2019-01-01 10:22:00.000000 | Tablet      | 2019-01-01 10:45:00 | *                  |
      | 1002        | 2019-01-01 11:14:00.000000 | Tablet      | 2019-01-01 11:15:00 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE           | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-01 10:15:00 | *                  |
      | 1001        | blue             | ab12         | 2019-01-01 10:45:00 | *                  |
      | 1001        | brown            | ab12         | 2019-01-01 11:15:00 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-01 10:15:00 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-01 10:45:00 | *                  |
      | 1002        | pink             | ef56         | 2019-01-01 11:15:00 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE          |
      | 2019-01-01 10:15:00 |
      | 2019-01-01 10:45:00 |
      | 2019-01-01 11:15:00 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE          | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS |
      | md5('1001') | 2019-01-01 10:15:00 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-01 10:15:00     | md5('1001')             | 2019-01-01 10:15:00       |
      | md5('1001') | 2019-01-01 10:45:00 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-01 10:45:00     | md5('1001')             | 2019-01-01 10:45:00       |
      | md5('1001') | 2019-01-01 11:15:00 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-01 11:15:00     | md5('1001')             | 2019-01-01 11:15:00       |
      | md5('1002') | 2019-01-01 10:15:00 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-01 10:15:00     | md5('1002')             | 2019-01-01 10:15:00       |
      | md5('1002') | 2019-01-01 10:45:00 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-01 10:45:00     | md5('1002')             | 2019-01-01 10:45:00       |
      | md5('1002') | 2019-01-01 11:15:00 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-01 11:15:00     | md5('1002')             | 2019-01-01 11:15:00       |

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-04] Load into a pit table where the AS OF table dates are before the satellites have received any entries and ghost records
    Given the PIT_CUSTOMER table does not exist
    Given the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2017-01-02 00:00:00.000000 |
      | 2017-01-03 00:00:00.000000 |
      | 2017-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK          | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK          | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2017-01-02 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2017-01-03 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2017-01-04 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2017-01-02 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2017-01-03 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2017-01-04 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-05] Load into a pit table where the AS OF table dates are after the most recent satellite entries and ghost records
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-05 00:00:00.000000 |
      | 2019-01-06 00:00:00.000000 |
      | 2019-01-07 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-05 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1001') | 2019-01-06 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1001') | 2019-01-07 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-05 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-06 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-07 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-06] Load into a pit table over several cycles where new record is introduced on the 3rd day and ghost records
    Given the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | Alice         | 5 Forrest road Hampshire | 1997-04-24   | 2019-01-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2019-01-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    When the RAW_STAGE_PROFILE is loaded
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-01 00:00:00.000000 | md5('1001')           | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-02 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2019-01-01 00:00:00.000000 | md5('1002')           | 2019-01-02 00:00:00.000000 | md5('1002')             | 2019-01-02 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-01 00:00:00.000000 | md5('1002')           | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-04 06:00:00.000000 | Tablet      | 2019-01-05 00:00:00.000000 | *      |
      | 1002        | 2019-01-04 04:00:00.000000 | Laptop      | 2019-01-05 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    When the RAW_STAGE_PROFILE is loaded
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | black            | ab12         | 2019-01-05 00:00:00.000000 | *      |
      | 1002        | red              | ef56         | 2019-01-05 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
      | 2019-01-05 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1001') | 2019-01-05 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-05 00:00:00.000000 | md5('1001')             | 2019-01-05 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-01 00:00:00.000000 | md5('1002')           | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-05 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-05 00:00:00.000000 | md5('1002')             | 2019-01-05 00:00:00.000000 |
    When the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1003        | Chad          | 4 Forrest road Hampshire | 1998-01-16   | 2019-01-06 00:00:00.000000 | *      |
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-05 06:00:00.000000 | Tablet      | 2019-01-06 00:00:00.000000 | *      |
      | 1002        | 2019-01-05 04:00:00.000000 | Laptop      | 2019-01-06 00:00:00.000000 | *      |
      | 1003        | 2019-01-05 03:00:00.000000 | Laptop      | 2019-01-06 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    When the RAW_STAGE_PROFILE is loaded
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | yellow           | ab12         | 2019-01-06 00:00:00.000000 | *      |
      | 1002        | purple           | ef56         | 2019-01-06 00:00:00.000000 | *      |
      | 1003        | black            | gh78         | 2019-01-06 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-04 00:00:00.000000 |
      | 2019-01-05 00:00:00.000000 |
      | 2019-01-06 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK          | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK          | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 | md5('1001')                      | 2019-01-04 00:00:00.000000 | md5('1001')                      | 2019-01-04 00:00:00.000000 |
      | md5('1001') | 2019-01-05 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 | md5('1001')                      | 2019-01-05 00:00:00.000000 | md5('1001')                      | 2019-01-05 00:00:00.000000 |
      | md5('1001') | 2019-01-06 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 | md5('1001')                      | 2019-01-06 00:00:00.000000 | md5('1001')                      | 2019-01-06 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-05 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2019-01-05 00:00:00.000000 | md5('1002')                      | 2019-01-05 00:00:00.000000 |
      | md5('1002') | 2019-01-06 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2019-01-06 00:00:00.000000 | md5('1002')                      | 2019-01-06 00:00:00.000000 |
      | md5('1003') | 2019-01-04 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2019-01-05 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2019-01-06 00:00:00.000000 | md5('1003')                      | 2019-01-06 00:00:00.000000 | md5('1003')                      | 2019-01-06 00:00:00.000000 | md5('1003')                      | 2019-01-06 00:00:00.000000 |

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-07] Load into a pit table where the as_of_dates table changes and ghost records
    Given the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | Alice         | 5 Forrest road Hampshire | 1997-04-24   | 2019-01-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2019-01-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    When the RAW_STAGE_PROFILE is loaded
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-01 00:00:00.000000 | md5('1001')           | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-02 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2019-01-01 00:00:00.000000 | md5('1002')           | 2019-01-02 00:00:00.000000 | md5('1002')             | 2019-01-02 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-01 00:00:00.000000 | md5('1002')           | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-04 06:00:00.000000 | Tablet      | 2019-01-05 00:00:00.000000 | *      |
      | 1002        | 2019-01-04 04:00:00.000000 | Laptop      | 2019-01-05 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    When the RAW_STAGE_PROFILE is loaded
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | black            | ab12         | 2019-01-05 00:00:00.000000 | *      |
      | 1002        | red              | ef56         | 2019-01-05 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-05 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-05 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-05 00:00:00.000000 | md5('1001')             | 2019-01-05 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-01 00:00:00.000000 | md5('1002')           | 2019-01-03 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-05 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-05 00:00:00.000000 | md5('1002')             | 2019-01-05 00:00:00.000000 |

  @fixture.pit_one_sat
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-08] Incremental load with the more recent AS OF timestamps into an already populated pit table from one satellite with timestamps and ghost records
    Given the PIT_CUSTOMER_1S_TS table does not exist
    And the raw vault contains empty tables
      | HUB                | LINK | SAT                     | PIT                |
      | HUB_CUSTOMER_1S_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_1S_TS |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE             |
      | <null>      | <null>        | <null>                    | <null>       | 1900-01-01 00:00:00.000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 00:00:00.000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 00:00:00.000 | *                  |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-01 23:59:59.999 | *                  |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 00:00:00.000 | *                  |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 12:00:00.001 | *                  |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-01 23:59:59.999 | *                  |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-05-31 12:00:00.000 |
      | 2018-06-01 00:00:00.000 |
      | 2018-06-01 12:00:00.000 |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 12:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK       | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-05-31 12:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-01 12:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-05-31 12:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-01 12:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                      | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')                      | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-05-31 12:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-01 12:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                      | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')                      | 2018-06-01 23:59:59.999      |
    When the RAW_STAGE_DETAILS_TS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1992-04-24   | 2018-06-02 12:00:00.001 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire | 1950-01-01   | 2018-06-02 23:59:59.999 | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE              |
      | 2018-06-02 00:00:00.000 |
      | 2018-06-02 12:00:00.000 |
      | 2018-06-03 00:00:00.000 |
    When I load the vault
    Then the PIT_CUSTOMER_1S_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK       | SAT_CUSTOMER_DETAILS_TS_LDTS |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-02 12:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                      | 2018-06-02 12:00:00.001      |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                      | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-02 12:00:00.000 | md5('1002')                      | 2018-06-01 23:59:59.999      |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                      | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                      | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-02 12:00:00.000 | md5('1003')                      | 2018-06-01 23:59:59.999      |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                      | 2018-06-01 23:59:59.999      |
      | md5('1004') | 2018-06-02 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      |
      | md5('1004') | 2018-06-02 12:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      |
      | md5('1004') | 2018-06-03 00:00:00.000 | md5('1004')                      | 2018-06-02 23:59:59.999      |

  @fixture.pit_two_sats
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-09] Base load into a pit table from two satellites with dates with an encompassing range of AS OF dates and ghost records
    Given the PIT_CUSTOMER_2S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_2S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_2S |
      |                 |      | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE             |
      | <null>      | <null>        | <null>                    | <null>       | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *                  |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *                  |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *                  |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *                  |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE             |
      | <null>      | <null>          | <null>      | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-02 | *                  |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-02 | *                  |
      | 1001        | 2018-06-03      | Phone       | 2018-06-04 | *                  |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *                  |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *                  |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *                  |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *                  |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *                  |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the PIT_CUSTOMER_2S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK          | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-01 00:00:00.000 |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-02 00:00:00.000 |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1003') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |

  @fixture.pit_two_sats
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-10] Incremental load with the more recent AS OF dates into an already populated pit table from two satellites with dates and ghost records
    Given the PIT_CUSTOMER_2S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_2S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_2S |
      |                 |      | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE             |
      | <null>      | <null>        | <null>                    | <null>       | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *                  |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-03 | *                  |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *                  |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-02 | *                  |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-03 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE             |
      | <null>      | <null>          | <null>      | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-03 | *                  |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-03 | *                  |
      | 1001        | 2018-06-03      | Phone       | 2018-06-03 | *                  |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *                  |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *                  |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *                  |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *                  |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *                  |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-02 |
      | 2018-06-04 |
    When I load the vault
    Then the PIT_CUSTOMER_2S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK          | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 | 00000000000000000000000000000000 | 1900-01-01                | 00000000000000000000000000000000 | 1900-01-01              |
      | md5('1002') | 2018-05-31 | 00000000000000000000000000000000 | 1900-01-01                | 00000000000000000000000000000000 | 1900-01-01              |
      | md5('1003') | 2018-05-31 | 00000000000000000000000000000000 | 1900-01-01                | 00000000000000000000000000000000 | 1900-01-01              |
      | md5('1001') | 2018-06-02 | md5('1001')                      | 2018-06-01                | 00000000000000000000000000000000 | 1900-01-01              |
      | md5('1002') | 2018-06-02 | md5('1002')                      | 2018-06-01                | md5('1002')                      | 2018-06-02              |
      | md5('1003') | 2018-06-02 | md5('1003')                      | 2018-06-02                | md5('1003')                      | 2018-06-01              |
      | md5('1001') | 2018-06-04 | md5('1001')                      | 2018-06-01                | md5('1001')                      | 2018-06-03              |
      | md5('1002') | 2018-06-04 | md5('1002')                      | 2018-06-03                | md5('1002')                      | 2018-06-03              |
      | md5('1003') | 2018-06-04 | md5('1003')                      | 2018-06-03                | md5('1003')                      | 2018-06-01              |
    When the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1992-04-24   | 2018-06-04 | *      |
      | 1004        | Dom           | 4 Forrest road Hampshire | 1950-01-01   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-03      | Tablet      | 2018-06-04 | *      |
      | 1002        | 2018-06-02      | Tablet      | 2018-06-04 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-05 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-05 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-05 | *      |
      | 1004        | 2018-06-04      | Laptop      | 2018-06-04 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-06-01 |
      | 2018-06-03 |
      | 2018-06-05 |
    When I load the vault
    Then the PIT_CUSTOMER_2S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PK          | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-06-01 | md5('1001')                      | 2018-06-01                | 00000000000000000000000000000000 | 1900-01-01              |
      | md5('1002') | 2018-06-01 | md5('1002')                      | 2018-06-01                | md5('1002')                      | 2018-06-01              |
      | md5('1003') | 2018-06-01 | md5('1003')                      | 2018-06-01                | md5('1003')                      | 2018-06-01              |
      | md5('1004') | 2018-06-01 | 00000000000000000000000000000000 | 1900-01-01                | 00000000000000000000000000000000 | 1900-01-01              |
      | md5('1001') | 2018-06-03 | md5('1001')                      | 2018-06-01                | md5('1001')                      | 2018-06-03              |
      | md5('1002') | 2018-06-03 | md5('1002')                      | 2018-06-03                | md5('1002')                      | 2018-06-03              |
      | md5('1003') | 2018-06-03 | md5('1003')                      | 2018-06-03                | md5('1003')                      | 2018-06-01              |
      | md5('1004') | 2018-06-03 | 00000000000000000000000000000000 | 1900-01-01                | 00000000000000000000000000000000 | 1900-01-01              |
      | md5('1001') | 2018-06-05 | md5('1001')                      | 2018-06-04                | md5('1001')                      | 2018-06-04              |
      | md5('1002') | 2018-06-05 | md5('1002')                      | 2018-06-03                | md5('1002')                      | 2018-06-04              |
      | md5('1003') | 2018-06-05 | md5('1003')                      | 2018-06-03                | md5('1003')                      | 2018-06-01              |
      | md5('1004') | 2018-06-05 | md5('1004')                      | 2018-06-05                | md5('1004')                      | 2018-06-04              |

  @fixture.pit_two_sats
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-11] PIT and SAT  cycle test with two satellites and ghost records in each and date
    Given the PIT_CUSTOMER_2S table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                  | PIT             |
      | HUB_CUSTOMER_2S |      | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER_2S |
      |                 |      | SAT_CUSTOMER_LOGIN   |                 |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01 | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05 | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03 | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE |
      | 1001        | 2018-06-01      | Tablet      | 2018-06-02 | *      |
      | 1001        | 2018-06-02      | Laptop      | 2018-06-02 | *      |
      | 1001        | 2018-06-03      | Phone       | 2018-06-04 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1002        | 2018-06-01      | Phone       | 2018-06-02 | *      |
      | 1002        | 2018-06-01      | Tablet      | 2018-06-03 | *      |
      | 1003        | 2018-06-01      | Phone       | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Tablet      | 2018-06-01 | *      |
      | 1003        | 2018-06-01      | Laptop      | 2018-06-01 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>                    | <null>       | 00000000000000000000000000000000                       | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01 | *                  |
      | md5('1002')                      | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01 | *                  |
      | md5('1002')                      | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05 | *                  |
      | md5('1003')                      | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01 | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03 | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05 | *                  |
    Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK                      | LAST_LOGIN_DATE | DEVICE_USED | LOAD_DATE  | SOURCE             | EFFECTIVE_FROM | HASHDIFF                         |
      | 00000000000000000000000000000000 | <null>          | <null>      | 1900-01-01 | AUTOMATE_DV_SYSTEM | 1900-01-01     | 00000000000000000000000000000000 |
      | md5('1001')                      | 2018-06-01      | Tablet      | 2018-06-02 | *                  | 2018-06-02     | md5('TABLET\|\|2018-06-01')      |
      | md5('1001')                      | 2018-06-02      | Laptop      | 2018-06-02 | *                  | 2018-06-02     | md5('LAPTOP\|\|2018-06-02')      |
      | md5('1001')                      | 2018-06-03      | Phone       | 2018-06-04 | *                  | 2018-06-04     | md5('PHONE\|\|2018-06-03')       |
      | md5('1002')                      | 2018-06-01      | Tablet      | 2018-06-01 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01')      |
      | md5('1002')                      | 2018-06-01      | Phone       | 2018-06-02 | *                  | 2018-06-02     | md5('PHONE\|\|2018-06-01')       |
      | md5('1002')                      | 2018-06-01      | Tablet      | 2018-06-03 | *                  | 2018-06-03     | md5('TABLET\|\|2018-06-01')      |
      | md5('1003')                      | 2018-06-01      | Phone       | 2018-06-01 | *                  | 2018-06-01     | md5('PHONE\|\|2018-06-01')       |
      | md5('1003')                      | 2018-06-01      | Tablet      | 2018-06-01 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01')      |
      | md5('1003')                      | 2018-06-01      | Laptop      | 2018-06-01 | *                  | 2018-06-01     | md5('LAPTOP\|\|2018-06-01')      |
    Then the PIT_CUSTOMER_2S table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_PK          | SAT_CUSTOMER_DETAILS_LDTS | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-02 00:00:00.000 |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-04 00:00:00.000 |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000   | md5('1001')                      | 2018-06-04 00:00:00.000 |
      | md5('1002') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-01 00:00:00.000 |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-02 00:00:00.000 |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000   | md5('1002')                      | 2018-06-03 00:00:00.000 |
      | md5('1003') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000   | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000 |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000   | md5('1003')                      | 2018-06-01 00:00:00.000 |

  @snowflake
  @fixture.pit_two_sats
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-12] PIT and SAT  cycle test with two satellites and ghost records in each and datetime
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
      |                 |      | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01    | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01    | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05    | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01    | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03    | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05    | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the RAW_STAGE_LOGIN_TS table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE     | DEVICE_USED | LOAD_DATETIME | SOURCE |
      | 1001        | 2018-06-01 00:00:00 | Tablet      | 2018-06-02    | *      |
      | 1001        | 2018-06-02 00:00:00 | Laptop      | 2018-06-02    | *      |
      | 1001        | 2018-06-03 00:00:00 | Phone       | 2018-06-04    | *      |
      | 1002        | 2018-06-01 00:00:00 | Tablet      | 2018-06-01    | *      |
      | 1002        | 2018-06-01 00:00:00 | Phone       | 2018-06-02    | *      |
      | 1002        | 2018-06-01 00:00:00 | Tablet      | 2018-06-03    | *      |
      | 1003        | 2018-06-01 00:00:00 | Phone       | 2018-06-01    | *      |
      | 1003        | 2018-06-01 00:00:00 | Tablet      | 2018-06-01    | *      |
      | 1003        | 2018-06-01 00:00:00 | Laptop      | 2018-06-01    | *      |
    And I stage the STG_CUSTOMER_LOGIN_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATETIME | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>                    | <null>       | 00000000000000000000000000000000                       | 1900-01-01     | 1900-01-01    | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1002')                      | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1002')                      | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05    | *                  |
      | md5('1003')                      | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03    | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05    | *                  |
    Then the SAT_CUSTOMER_LOGIN_TS table should contain expected data
      | CUSTOMER_PK                      | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE             | EFFECTIVE_FROM | HASHDIFF                                 |
      | 00000000000000000000000000000000 | <null>                  | <null>      | 1900-01-01 00:00:00.000 | AUTOMATE_DV_SYSTEM | 1900-01-01     | 00000000000000000000000000000000         |
      | md5('1001')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-02 00:00:00.000 | *                  | 2018-06-02     | md5('TABLET\|\|2018-06-01 00:00:00.000') |
      | md5('1001')                      | 2018-06-02 00:00:00.000 | Laptop      | 2018-06-02 00:00:00.000 | *                  | 2018-06-02     | md5('LAPTOP\|\|2018-06-02 00:00:00.000') |
      | md5('1001')                      | 2018-06-03 00:00:00.000 | Phone       | 2018-06-04 00:00:00.000 | *                  | 2018-06-04     | md5('PHONE\|\|2018-06-03 00:00:00.000')  |
      | md5('1002')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01 00:00:00.000') |
      | md5('1002')                      | 2018-06-01 00:00:00.000 | Phone       | 2018-06-02 00:00:00.000 | *                  | 2018-06-02     | md5('PHONE\|\|2018-06-01 00:00:00.000')  |
      | md5('1002')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-03 00:00:00.000 | *                  | 2018-06-03     | md5('TABLET\|\|2018-06-01 00:00:00.000') |
      | md5('1003')                      | 2018-06-01 00:00:00.000 | Phone       | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('PHONE\|\|2018-06-01 00:00:00.000')  |
      | md5('1003')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01 00:00:00.000') |
      | md5('1003')                      | 2018-06-01 00:00:00.000 | Laptop      | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('LAPTOP\|\|2018-06-01 00:00:00.000') |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK       | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK         | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-02 00:00:00.000    |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-02 00:00:00.000    |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-04 00:00:00.000    |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-04 00:00:00.000    |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-04 00:00:00.000    |
      | md5('1002') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-01 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1003') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |

  @bigquery
  @fixture.pit_two_sats
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-13] PIT and SAT  cycle test with two satellites and ghost records in each and datetime
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
      |                 |      | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01    | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01    | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05    | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01    | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03    | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05    | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the RAW_STAGE_LOGIN_TS table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE     | DEVICE_USED | LOAD_DATETIME | SOURCE |
      | 1001        | 2018-06-01 00:00:00 | Tablet      | 2018-06-02    | *      |
      | 1001        | 2018-06-02 00:00:00 | Laptop      | 2018-06-02    | *      |
      | 1001        | 2018-06-03 00:00:00 | Phone       | 2018-06-04    | *      |
      | 1002        | 2018-06-01 00:00:00 | Tablet      | 2018-06-01    | *      |
      | 1002        | 2018-06-01 00:00:00 | Phone       | 2018-06-02    | *      |
      | 1002        | 2018-06-01 00:00:00 | Tablet      | 2018-06-03    | *      |
      | 1003        | 2018-06-01 00:00:00 | Phone       | 2018-06-01    | *      |
      | 1003        | 2018-06-01 00:00:00 | Tablet      | 2018-06-01    | *      |
      | 1003        | 2018-06-01 00:00:00 | Laptop      | 2018-06-01    | *      |
    And I stage the STG_CUSTOMER_LOGIN_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATETIME | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>                    | <null>       | 00000000000000000000000000000000                       | 1900-01-01     | 1900-01-01    | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1002')                      | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1002')                      | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05    | *                  |
      | md5('1003')                      | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03    | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05    | *                  |
    Then the SAT_CUSTOMER_LOGIN_TS table should contain expected data
      | CUSTOMER_PK                      | LAST_LOGIN_DATE     | DEVICE_USED | LOAD_DATETIME       | SOURCE             | EFFECTIVE_FROM | HASHDIFF                             |
      | 00000000000000000000000000000000 | <null>              | <null>      | 1900-01-01 00:00:00 | AUTOMATE_DV_SYSTEM | 1900-01-01     | 00000000000000000000000000000000     |
      | md5('1001')                      | 2018-06-01 00:00:00 | Tablet      | 2018-06-02 00:00:00 | *                  | 2018-06-02     | md5('TABLET\|\|2018-06-01 00:00:00') |
      | md5('1001')                      | 2018-06-02 00:00:00 | Laptop      | 2018-06-02 00:00:00 | *                  | 2018-06-02     | md5('LAPTOP\|\|2018-06-02 00:00:00') |
      | md5('1001')                      | 2018-06-03 00:00:00 | Phone       | 2018-06-04 00:00:00 | *                  | 2018-06-04     | md5('PHONE\|\|2018-06-03 00:00:00')  |
      | md5('1002')                      | 2018-06-01 00:00:00 | Tablet      | 2018-06-01 00:00:00 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01 00:00:00') |
      | md5('1002')                      | 2018-06-01 00:00:00 | Phone       | 2018-06-02 00:00:00 | *                  | 2018-06-02     | md5('PHONE\|\|2018-06-01 00:00:00')  |
      | md5('1002')                      | 2018-06-01 00:00:00 | Tablet      | 2018-06-03 00:00:00 | *                  | 2018-06-03     | md5('TABLET\|\|2018-06-01 00:00:00') |
      | md5('1003')                      | 2018-06-01 00:00:00 | Phone       | 2018-06-01 00:00:00 | *                  | 2018-06-01     | md5('PHONE\|\|2018-06-01 00:00:00')  |
      | md5('1003')                      | 2018-06-01 00:00:00 | Tablet      | 2018-06-01 00:00:00 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01 00:00:00') |
      | md5('1003')                      | 2018-06-01 00:00:00 | Laptop      | 2018-06-01 00:00:00 | *                  | 2018-06-01     | md5('LAPTOP\|\|2018-06-01 00:00:00') |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE          | SAT_CUSTOMER_DETAILS_TS_PK       | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK         | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00 | 00000000000000000000000000000000 | 1900-01-01 00:00:00          | 00000000000000000000000000000000 | 1900-01-01 00:00:00        |
      | md5('1001') | 2018-06-01 00:00:00 | md5('1001')                      | 2018-06-01 00:00:00          | 00000000000000000000000000000000 | 1900-01-01 00:00:00        |
      | md5('1001') | 2018-06-02 00:00:00 | md5('1001')                      | 2018-06-01 00:00:00          | md5('1001')                      | 2018-06-02 00:00:00        |
      | md5('1001') | 2018-06-03 00:00:00 | md5('1001')                      | 2018-06-01 00:00:00          | md5('1001')                      | 2018-06-02 00:00:00        |
      | md5('1001') | 2018-06-04 00:00:00 | md5('1001')                      | 2018-06-01 00:00:00          | md5('1001')                      | 2018-06-04 00:00:00        |
      | md5('1001') | 2018-06-05 00:00:00 | md5('1001')                      | 2018-06-01 00:00:00          | md5('1001')                      | 2018-06-04 00:00:00        |
      | md5('1001') | 2018-06-06 00:00:00 | md5('1001')                      | 2018-06-01 00:00:00          | md5('1001')                      | 2018-06-04 00:00:00        |
      | md5('1002') | 2018-05-31 00:00:00 | 00000000000000000000000000000000 | 1900-01-01 00:00:00          | 00000000000000000000000000000000 | 1900-01-01 00:00:00        |
      | md5('1002') | 2018-06-01 00:00:00 | md5('1002')                      | 2018-06-01 00:00:00          | md5('1002')                      | 2018-06-01 00:00:00        |
      | md5('1002') | 2018-06-02 00:00:00 | md5('1002')                      | 2018-06-01 00:00:00          | md5('1002')                      | 2018-06-02 00:00:00        |
      | md5('1002') | 2018-06-03 00:00:00 | md5('1002')                      | 2018-06-01 00:00:00          | md5('1002')                      | 2018-06-03 00:00:00        |
      | md5('1002') | 2018-06-04 00:00:00 | md5('1002')                      | 2018-06-01 00:00:00          | md5('1002')                      | 2018-06-03 00:00:00        |
      | md5('1002') | 2018-06-05 00:00:00 | md5('1002')                      | 2018-06-05 00:00:00          | md5('1002')                      | 2018-06-03 00:00:00        |
      | md5('1002') | 2018-06-06 00:00:00 | md5('1002')                      | 2018-06-05 00:00:00          | md5('1002')                      | 2018-06-03 00:00:00        |
      | md5('1003') | 2018-05-31 00:00:00 | 00000000000000000000000000000000 | 1900-01-01 00:00:00          | 00000000000000000000000000000000 | 1900-01-01 00:00:00        |
      | md5('1003') | 2018-06-01 00:00:00 | md5('1003')                      | 2018-06-01 00:00:00          | md5('1003')                      | 2018-06-01 00:00:00        |
      | md5('1003') | 2018-06-02 00:00:00 | md5('1003')                      | 2018-06-01 00:00:00          | md5('1003')                      | 2018-06-01 00:00:00        |
      | md5('1003') | 2018-06-03 00:00:00 | md5('1003')                      | 2018-06-03 00:00:00          | md5('1003')                      | 2018-06-01 00:00:00        |
      | md5('1003') | 2018-06-04 00:00:00 | md5('1003')                      | 2018-06-03 00:00:00          | md5('1003')                      | 2018-06-01 00:00:00        |
      | md5('1003') | 2018-06-05 00:00:00 | md5('1003')                      | 2018-06-05 00:00:00          | md5('1003')                      | 2018-06-01 00:00:00        |
      | md5('1003') | 2018-06-06 00:00:00 | md5('1003')                      | 2018-06-05 00:00:00          | md5('1003')                      | 2018-06-01 00:00:00        |

  @sqlserver
  @fixture.pit_two_sats
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-14] PIT and SAT  cycle test with two satellites and ghost records in each and datetime
    Given the PIT_CUSTOMER_TS table does not exist
    And the raw vault contains empty tables
      | HUB             | LINK | SAT                     | PIT             |
      | HUB_CUSTOMER_TS |      | SAT_CUSTOMER_DETAILS_TS | PIT_CUSTOMER_TS |
      |                 |      | SAT_CUSTOMER_LOGIN_TS   |                 |
    And the RAW_STAGE_DETAILS_TS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | LOAD_DATETIME | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | 2018-06-01    | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | 2018-06-01    | *      |
      | 1002        | Bob           | 22 Forrest road Hampshire | 2006-04-17   | 2018-06-05    | *      |
      | 1003        | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-01    | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | 2018-06-03    | *      |
      | 1003        | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | 2018-06-05    | *      |
    And I stage the STG_CUSTOMER_DETAILS_TS data
    And the RAW_STAGE_LOGIN_TS table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE     | DEVICE_USED | LOAD_DATETIME | SOURCE |
      | 1001        | 2018-06-01 00:00:00 | Tablet      | 2018-06-02    | *      |
      | 1001        | 2018-06-02 00:00:00 | Laptop      | 2018-06-02    | *      |
      | 1001        | 2018-06-03 00:00:00 | Phone       | 2018-06-04    | *      |
      | 1002        | 2018-06-01 00:00:00 | Tablet      | 2018-06-01    | *      |
      | 1002        | 2018-06-01 00:00:00 | Phone       | 2018-06-02    | *      |
      | 1002        | 2018-06-01 00:00:00 | Tablet      | 2018-06-03    | *      |
      | 1003        | 2018-06-01 00:00:00 | Phone       | 2018-06-01    | *      |
      | 1003        | 2018-06-01 00:00:00 | Tablet      | 2018-06-01    | *      |
      | 1003        | 2018-06-01 00:00:00 | Laptop      | 2018-06-01    | *      |
    And I stage the STG_CUSTOMER_LOGIN_TS data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE |
      | 2018-05-31 |
      | 2018-06-01 |
      | 2018-06-02 |
      | 2018-06-03 |
      | 2018-06-04 |
      | 2018-06-05 |
      | 2018-06-06 |
    When I load the vault
    Then the SAT_CUSTOMER_DETAILS_TS table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_ADDRESS          | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATETIME | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>                    | <null>       | 00000000000000000000000000000000                       | 1900-01-01     | 1900-01-01    | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 1 Forrest road Hampshire  | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1002')                      | Bob           | 2 Forrest road Hampshire  | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1002')                      | Bob           | 22 Forrest road Hampshire | 2006-04-17   | md5('22 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')  | 2018-06-05     | 2018-06-05    | *                  |
      | md5('1003')                      | Chad          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAD')  | 2018-06-01     | 2018-06-01    | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-12   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-12\|\|CHAZ')  | 2018-06-03     | 2018-06-03    | *                  |
      | md5('1003')                      | Chaz          | 3 Forrest road Hampshire  | 1988-02-11   | md5('3 FORREST ROAD HAMPSHIRE\|\|1988-02-11\|\|CHAZ')  | 2018-06-05     | 2018-06-05    | *                  |
    Then the SAT_CUSTOMER_LOGIN_TS table should contain expected data
      | CUSTOMER_PK                      | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATETIME           | SOURCE             | EFFECTIVE_FROM | HASHDIFF                                     |
      | 00000000000000000000000000000000 | <null>                  | <null>      | 1900-01-01 00:00:00.000 | AUTOMATE_DV_SYSTEM | 1900-01-01     | 00000000000000000000000000000000             |
      | md5('1001')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-02 00:00:00.000 | *                  | 2018-06-02     | md5('TABLET\|\|2018-06-01 00:00:00.0000000') |
      | md5('1001')                      | 2018-06-02 00:00:00.000 | Laptop      | 2018-06-02 00:00:00.000 | *                  | 2018-06-02     | md5('LAPTOP\|\|2018-06-02 00:00:00.0000000') |
      | md5('1001')                      | 2018-06-03 00:00:00.000 | Phone       | 2018-06-04 00:00:00.000 | *                  | 2018-06-04     | md5('PHONE\|\|2018-06-03 00:00:00.0000000')  |
      | md5('1002')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01 00:00:00.0000000') |
      | md5('1002')                      | 2018-06-01 00:00:00.000 | Phone       | 2018-06-02 00:00:00.000 | *                  | 2018-06-02     | md5('PHONE\|\|2018-06-01 00:00:00.0000000')  |
      | md5('1002')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-03 00:00:00.000 | *                  | 2018-06-03     | md5('TABLET\|\|2018-06-01 00:00:00.0000000') |
      | md5('1003')                      | 2018-06-01 00:00:00.000 | Phone       | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('PHONE\|\|2018-06-01 00:00:00.0000000')  |
      | md5('1003')                      | 2018-06-01 00:00:00.000 | Tablet      | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('TABLET\|\|2018-06-01 00:00:00.0000000') |
      | md5('1003')                      | 2018-06-01 00:00:00.000 | Laptop      | 2018-06-01 00:00:00.000 | *                  | 2018-06-01     | md5('LAPTOP\|\|2018-06-01 00:00:00.0000000') |
    Then the PIT_CUSTOMER_TS table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE              | SAT_CUSTOMER_DETAILS_TS_PK       | SAT_CUSTOMER_DETAILS_TS_LDTS | SAT_CUSTOMER_LOGIN_TS_PK         | SAT_CUSTOMER_LOGIN_TS_LDTS |
      | md5('1001') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-01 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1001') | 2018-06-02 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-02 00:00:00.000    |
      | md5('1001') | 2018-06-03 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-02 00:00:00.000    |
      | md5('1001') | 2018-06-04 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-04 00:00:00.000    |
      | md5('1001') | 2018-06-05 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-04 00:00:00.000    |
      | md5('1001') | 2018-06-06 00:00:00.000 | md5('1001')                      | 2018-06-01 00:00:00.000      | md5('1001')                      | 2018-06-04 00:00:00.000    |
      | md5('1002') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1002') | 2018-06-01 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-01 00:00:00.000    |
      | md5('1002') | 2018-06-02 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-02 00:00:00.000    |
      | md5('1002') | 2018-06-03 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1002') | 2018-06-04 00:00:00.000 | md5('1002')                      | 2018-06-01 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1002') | 2018-06-05 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1002') | 2018-06-06 00:00:00.000 | md5('1002')                      | 2018-06-05 00:00:00.000      | md5('1002')                      | 2018-06-03 00:00:00.000    |
      | md5('1003') | 2018-05-31 00:00:00.000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000      | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000    |
      | md5('1003') | 2018-06-01 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-02 00:00:00.000 | md5('1003')                      | 2018-06-01 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-03 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-04 00:00:00.000 | md5('1003')                      | 2018-06-03 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-05 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |
      | md5('1003') | 2018-06-06 00:00:00.000 | md5('1003')                      | 2018-06-05 00:00:00.000      | md5('1003')                      | 2018-06-01 00:00:00.000    |

  @fixture.pit
  @fixture.enable_ghost_records
  Scenario: [PIT-GR-15] Load into a pit table where the AS OF table is already established but a load date in a satellite is the same as the ghost load date
    Given the PIT_CUSTOMER table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>        | <null>                   | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *                  |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *                  |
      | 1003        | Janet         | 4 Forrest road Hampshire | 2000-06-23   | 1900-01-01 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>                     | <null>      | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | 2019-01-01 02:00:00.000000 | Phone       | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *                  |
      | 1003        | 2019-01-02 03:00:00.000000 | Laptop      | 2019-01-03 00:00:00.000000 | *                  |
      | 1003        | 2019-01-02 11:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE             |
      | <null>      | <null>           | <null>       | 1900-01-01 00:00:00.000000 | AUTOMATE_DV_SYSTEM |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *                  |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *                  |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *                  |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *                  |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *                  |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *                  |
      | 1003        | orange           | gh78         | 2019-01-04 00:00:00.000000 | *                  |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK            | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK          | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-02 00:00:00.000000 | md5('1001')                      | 2019-01-02 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 | md5('1001')                      | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')                      | 2019-01-04 00:00:00.000000 | md5('1001')                      | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | md5('1002')                      | 2019-01-02 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | md5('1002')                      | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 | md5('1002')                      | 2019-01-04 00:00:00.000000 |
      | md5('1003') | 2019-01-02 00:00:00.000000 | md5('1003')             | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2019-01-03 00:00:00.000000 | md5('1003')             | 1900-01-01 00:00:00.000000 | md5('1003')                      | 2019-01-03 00:00:00.000000 | 00000000000000000000000000000000 | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2019-01-04 00:00:00.000000 | md5('1003')             | 1900-01-01 00:00:00.000000 | md5('1003')                      | 2019-01-03 00:00:00.000000 | md5('1003')                      | 2019-01-04 00:00:00.000000 |
