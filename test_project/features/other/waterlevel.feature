Feature: Period Materialisation gets date range from Waterlevel table

  @fixture.single_source_hub_waterlevel
  Scenario: [WATERLEVEL-HUB-S] Simple load of stage data into an empty hub where the date column is the same everywhere
    Given the HUB_WL_1 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-04 | TPCH   |
    And I create the STG_CUSTOMER stage
    And the HUB_WATERLEVEL table is created and populated with data
      | TYPE  | LOAD_DATE  |
      | START | 1993-01-01 |
      | END   | 1993-01-04 |
    And I insert by period, with a waterlevel table into the HUB_WL_1 hub by day
    And I insert by period, with a waterlevel table into the HUB_WL_1 hub by day
    Then the HUB_WL_1 table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |

  @fixture.single_source_hub_waterlevel
  Scenario: [WATERLEVEL-HUB-HUB] Simple load of stage data into an empty hub where the date column is different in the HUB
    Given the HUB_WL_2 table does not exist
    And the RAW_STAGE_LDTS table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1993-01-01 00:00:00.000 | TPCH   |
      | 1001        | Alice         | 1993-01-01 00:00:00.000 | TPCH   |
      | 1002        | Bob           | 1993-01-02 00:00:00.000 | TPCH   |
      | 1002        | Bob           | 1993-01-02 00:00:00.000 | TPCH   |
      | 1002        | Bob           | 1993-01-02 00:00:00.000 | TPCH   |
      | 1003        | Chad          | 1993-01-03 00:00:00.000 | TPCH   |
      | 1004        | Dom           | 1993-01-04 00:00:00.000 | TPCH   |
    And I create the STG_CUSTOMER stage
    And the HUB_WATERLEVEL table is created and populated with data
      | TYPE  | LOAD_DATE  |
      | START | 1993-01-01 |
      | END   | 1993-01-04 |
    And I insert by period, with a waterlevel table into the HUB_WL_2 hub by day
    And I insert by period, with a waterlevel table into the HUB_WL_2 hub by day
    Then the HUB_WL_2 table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATETIME           | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 00:00:00.000 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 00:00:00.000 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 00:00:00.000 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 00:00:00.000 | TPCH   |

  @fixture.single_source_hub_waterlevel
  Scenario: [WATERLEVEL-HUB-WL] Simple load of stage data into an empty hub where the date column is different in the waterlevel table
    Given the HUB_WL_3 table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-04 | TPCH   |
    And I create the STG_CUSTOMER stage
    And the HUB_WATERLEVEL_LDTS table is created and populated with data
      | TYPE  | LOAD_DATETIME           |
      | START | 1993-01-01 00:00:00.000 |
      | END   | 1993-01-04 23:59:59.999 |
    And I insert by period, with a waterlevel table into the HUB_WL_3 hub by day
    And I insert by period, with a waterlevel table into the HUB_WL_3 hub by day
    Then the HUB_WL_3 table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |