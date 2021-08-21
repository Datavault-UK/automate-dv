Feature: [BQ-PIT] Point in Time

  @fixture.pit
  Scenario: [BQ-PIT-001] Load into a pit table where the AS OF table is already established with increments of a day
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-01 02:00:00.123000 | Phone       | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | 2019-01-02 03:00:00.000000 | Phone       | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | 2019-01-03 01:00:00.000000 | Laptop      | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | 2019-01-01 05:00:00.000000 | Tablet      | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | 2019-01-02 06:00:00.000000 | Tablet      | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | 2019-01-03 08:00:00.000000 | Tablet      | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_PROFILE data
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
    Then the SAT_CUSTOMER_DETAILS table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | Alice         | 1 Forrest road Hampshire | 1997-04-24   | md5('1 FORREST ROAD HAMPSHIRE\|\|1997-04-24\|\|ALICE') | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 2 Forrest road Hampshire | 2006-04-17   | md5('2 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-06-01 00:00:00.000000 | 2018-06-01 00:00:00.000000 | *      |
      | md5('1002') | Bob           | 3 Forrest road Hampshire | 2006-04-17   | md5('3 FORREST ROAD HAMPSHIRE\|\|2006-04-17\|\|BOB')   | 2018-12-01 00:00:00.000000 | 2018-12-01 00:00:00.000000 | *      |
     Then the SAT_CUSTOMER_LOGIN table should contain expected data
      | CUSTOMER_PK | LAST_LOGIN_DATE            | DEVICE_USED | HASHDIFF                                 | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | 2019-01-01 02:00:00.123000 | Phone       | md5('PHONE\|\|2019-01-01 02:00:00.123')  | 2019-01-02 00:00:00.000000 | 2019-01-02 00:00:00.000000 | *      |
      | md5('1001') | 2019-01-02 03:00:00.000000 | Phone       | md5('PHONE\|\|2019-01-02 03:00:00')      | 2019-01-03 00:00:00.000000 | 2019-01-03 00:00:00.000000 | *      |
      | md5('1001') | 2019-01-03 01:00:00.000000 | Laptop      | md5('LAPTOP\|\|2019-01-03 01:00:00')     | 2019-01-04 00:00:00.000000 | 2019-01-04 00:00:00.000000 | *      |
      | md5('1002') | 2019-01-01 05:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-01 05:00:00')     | 2019-01-02 00:00:00.000000 | 2019-01-02 00:00:00.000000 | *      |
      | md5('1002') | 2019-01-02 06:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-02 06:00:00')     | 2019-01-03 00:00:00.000000 | 2019-01-03 00:00:00.000000 | *      |
      | md5('1002') | 2019-01-03 08:00:00.000000 | Tablet      | md5('TABLET\|\|2019-01-03 08:00:00')     | 2019-01-04 00:00:00.000000 | 2019-01-04 00:00:00.000000 | *      |
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

  @fixture.pit
  Scenario: [BQ-PIT-002] Load into a pit table where the AS OF table is already established but the final pit table will deal with NULL Values as ghosts
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-01 02:00:00.234 | Phone       | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | 2019-01-02 03:00:00     | Phone       | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | 2019-01-03 01:00:00     | Laptop      | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | 2019-01-03 08:00:00     | Tablet      | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2019-01-02 00:00:00.000000 |
      | 2019-01-03 00:00:00.000000 |
      | 2019-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-02 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-02 00:00:00.000000 | md5('1001')             | 2019-01-02 00:00:00.000000 |
      | md5('1001') | 2019-01-03 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-03 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2018-06-01 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-02 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | md5('1002')             | 2019-01-02 00:00:00.000000 |
      | md5('1002') | 2019-01-03 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | md5('1002')             | 2019-01-03 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2018-12-01 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |

  @fixture.pit
  Scenario: [BQ-PIT-003] Load into a pit table where the AS OF table is already established and the AS OF table has increments of 30 mins
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE         | DEVICE_USED | LOAD_DATE           | SOURCE |
      | 1001        | 2019-01-01 10:01:00     | Phone       | 2019-01-01 10:15:00 | *      |
      | 1001        | 2019-01-01 10:36:00.345 | Phone       | 2019-01-01 10:45:00 | *      |
      | 1001        | 2019-01-01 10:56:00     | Laptop      | 2019-01-01 11:15:00 | *      |
      | 1002        | 2019-01-01 09:55:00     | Tablet      | 2019-01-01 10:15:00 | *      |
      | 1002        | 2019-01-01 10:22:00     | Tablet      | 2019-01-01 10:45:00 | *      |
      | 1002        | 2019-01-01 11:14:00     | Tablet      | 2019-01-01 11:15:00 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE           | SOURCE |
      | 1001        | red              | ab12         | 2019-01-01 10:15:00 | *      |
      | 1001        | blue             | ab12         | 2019-01-01 10:45:00 | *      |
      | 1001        | brown            | ab12         | 2019-01-01 11:15:00 | *      |
      | 1002        | yellow           | cd34         | 2019-01-01 10:15:00 | *      |
      | 1002        | yellow           | ef56         | 2019-01-01 10:45:00 | *      |
      | 1002        | pink             | ef56         | 2019-01-01 11:15:00 | *      |
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
  Scenario: [BQ-PIT-004] Load into a pit table where the AS OF table dates are before the satellites have received any entry's
    Given the PIT table does not exist
    Given the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-01 02:00:00 | Phone       | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | 2019-01-02 03:00:00 | Phone       | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | 2019-01-03 01:00:00 | Laptop      | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | 2019-01-01 05:00:00 | Tablet      | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | 2019-01-02 06:00:00 | Tablet      | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | 2019-01-03 08:00:00 | Tablet      | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_PROFILE data
    And the AS_OF_DATE table is created and populated with data
      | AS_OF_DATE                 |
      | 2017-01-02 00:00:00.000000 |
      | 2017-01-03 00:00:00.000000 |
      | 2017-01-04 00:00:00.000000 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2017-01-02 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2017-01-03 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1001') | 2017-01-04 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2017-01-02 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2017-01-03 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1002') | 2017-01-04 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |

  @fixture.pit
  Scenario: [BQ-PIT-005] Load into a pit table where the AS OF table dates are after the most recent satellite entry's
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2018-06-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2018-12-01 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    And the RAW_STAGE_LOGIN table contains data
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-01 02:00:00 | Phone       | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | 2019-01-02 03:00:00 | Phone       | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | 2019-01-03 01:00:00 | Laptop      | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | 2019-01-01 05:00:00 | Tablet      | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | 2019-01-02 06:00:00 | Tablet      | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | 2019-01-03 08:00:00 | Tablet      | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    And the RAW_STAGE_PROFILE table contains data
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *      |
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
  Scenario: [BQ-PIT-006] Load into a pit table over several cycles where new record is introduced on the 3rd day
    Given the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | Alice         | 5 Forrest road Hampshire | 1997-04-24   | 2019-01-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2019-01-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-01 02:00:00 | Phone       | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | 2019-01-02 03:00:00 | Phone       | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | 2019-01-03 01:00:00 | Laptop      | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | 2019-01-01 05:00:00 | Tablet      | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | 2019-01-02 06:00:00 | Tablet      | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | 2019-01-03 08:00:00 | Tablet      | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    When the RAW_STAGE_PROFILE is loaded
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *      |
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
      | 1001        | 2019-01-04 06:00:00 | Tablet      | 2019-01-05 00:00:00.000000 | *      |
      | 1002        | 2019-01-04 04:00:00 | Laptop      | 2019-01-05 00:00:00.000000 | *      |
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
      | 1001        | 2019-01-05 06:00:00 | Tablet      | 2019-01-06 00:00:00.000000 | *      |
      | 1002        | 2019-01-05 04:00:00 | Laptop      | 2019-01-06 00:00:00.000000 | *      |
      | 1003        | 2019-01-05 03:00:00 | Laptop      | 2019-01-06 00:00:00.000000 | *      |
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
      | CUSTOMER_PK | AS_OF_DATE                 | SAT_CUSTOMER_DETAILS_PK | SAT_CUSTOMER_DETAILS_LDTS  | SAT_CUSTOMER_LOGIN_PK | SAT_CUSTOMER_LOGIN_LDTS    | SAT_CUSTOMER_PROFILE_PK | SAT_CUSTOMER_PROFILE_LDTS  |
      | md5('1001') | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-04 00:00:00.000000 | md5('1001')             | 2019-01-04 00:00:00.000000 |
      | md5('1001') | 2019-01-05 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-05 00:00:00.000000 | md5('1001')             | 2019-01-05 00:00:00.000000 |
      | md5('1001') | 2019-01-06 00:00:00.000000 | md5('1001')             | 2019-01-03 00:00:00.000000 | md5('1001')           | 2019-01-06 00:00:00.000000 | md5('1001')             | 2019-01-06 00:00:00.000000 |
      | md5('1002') | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-04 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 |
      | md5('1002') | 2019-01-05 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-05 00:00:00.000000 | md5('1002')             | 2019-01-05 00:00:00.000000 |
      | md5('1002') | 2019-01-06 00:00:00.000000 | md5('1002')             | 2019-01-04 00:00:00.000000 | md5('1002')           | 2019-01-06 00:00:00.000000 | md5('1002')             | 2019-01-06 00:00:00.000000 |
      | md5('1003') | 2019-01-04 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2019-01-05 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 | 0000000000000000      | 1900-01-01 00:00:00.000000 | 0000000000000000        | 1900-01-01 00:00:00.000000 |
      | md5('1003') | 2019-01-06 00:00:00.000000 | md5('1003')             | 2019-01-06 00:00:00.000000 | md5('1003')           | 2019-01-06 00:00:00.000000 | md5('1003')             | 2019-01-06 00:00:00.000000 |

  @fixture.pit
  Scenario: [BQ-PIT-007] Load into a pit table where the as_of_dates table changes
    Given the raw vault contains empty tables
      | HUB          | SAT                  | PIT          |
      | HUB_CUSTOMER | SAT_CUSTOMER_DETAILS | PIT_CUSTOMER |
      |              | SAT_CUSTOMER_LOGIN   |              |
      |              | SAT_CUSTOMER_PROFILE |              |
    And the RAW_STAGE_DETAILS is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_ADDRESS         | CUSTOMER_DOB | LOAD_DATE                  | SOURCE |
      | 1001        | Alice         | 1 Forrest road Hampshire | 1997-04-24   | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | Alice         | 5 Forrest road Hampshire | 1997-04-24   | 2019-01-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 2 Forrest road Hampshire | 2006-04-17   | 2019-01-01 00:00:00.000000 | *      |
      | 1002        | Bob           | 3 Forrest road Hampshire | 2006-04-17   | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_DETAILS data
    When the RAW_STAGE_LOGIN is loaded
      | CUSTOMER_ID | LAST_LOGIN_DATE            | DEVICE_USED | LOAD_DATE                  | SOURCE |
      | 1001        | 2019-01-01 02:00:00.435 | Phone       | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | 2019-01-02 03:00:00     | Phone       | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | 2019-01-03 01:00:00.768 | Laptop      | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | 2019-01-01 05:00:00     | Tablet      | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | 2019-01-02 06:00:00     | Tablet      | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | 2019-01-03 08:00:00     | Tablet      | 2019-01-04 00:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_LOGIN data
    When the RAW_STAGE_PROFILE is loaded
      | CUSTOMER_ID | DASHBOARD_COLOUR | DISPLAY_NAME | LOAD_DATE                  | SOURCE |
      | 1001        | red              | ab12         | 2019-01-02 00:00:00.000000 | *      |
      | 1001        | blue             | ab12         | 2019-01-03 00:00:00.000000 | *      |
      | 1001        | brown            | ab12         | 2019-01-04 00:00:00.000000 | *      |
      | 1002        | yellow           | cd34         | 2019-01-02 00:00:00.000000 | *      |
      | 1002        | yellow           | ef56         | 2019-01-03 00:00:00.000000 | *      |
      | 1002        | pink             | ef56         | 2019-01-04 00:00:00.000000 | *      |
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
      | 1001        | 2019-01-04 06:00:00 | Tablet      | 2019-01-05 00:00:00.000000 | *      |
      | 1002        | 2019-01-04 04:00:00 | Laptop      | 2019-01-05 00:00:00.000000 | *      |
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

