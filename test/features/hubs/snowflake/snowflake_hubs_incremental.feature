Feature: [SF-HUB] Hubs Loaded using Incremental Materialization

# Tests from snowflake_hubs.feature that should be moved here:
# [SF-HUB-08] Load of stage data into a hub
# [SF-HUB-09] Load of distinct stage data into a hub  (?)
# [SF-HUB-014] Union three staging tables to feed an empty hub over two cycles
# [SF-HUB-015] Union three staging tables to feed a populated hub

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-01] Load of empty stage into an non-existent hub - one cycle
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-02] Load of mixed stage data into an non-existent hub - one cycle
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-03] Load of mixed stage data into an non-existent hub - two cycles
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-03 | TPCH   |
      | 1002        | Bob           | 1993-01-03 | TPCH   |
      | 1003        | Chadwick      | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-03 | TPCH   |
      | 1005        | Ewan          | 1993-01-03 | TPCH   |
      | 1006        | Fred          | 1993-01-03 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |
      | md5('1005') | 1005        | 1993-01-03 | TPCH   |
      | md5('1006') | 1006        | 1993-01-03 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-04] Load of empty stage data into an empty hub - two cycles
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-05] Load of stage data into an empty hub - one cycle
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-06] Load of mixed stage data into an empty hub - two cycles
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1002        | Bobby         | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-07] Load of empty stage data into a populated hub - one cycle
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-08] Load of mixed stage data into a populated hub - one cycle
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-02 | TPCH   |
      | 1002        | Bobby         | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [SF-HUB-IM-09] Load of mixed stage data into a populated hub - two cycles
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-03 | TPCH   |
      | 1002        | Bob           | 1993-01-03 | TPCH   |
      | 1003        | Chadwick      | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-03 | TPCH   |
      | 1005        | Ewan          | 1993-01-03 | TPCH   |
      | 1006        | Fred          | 1993-01-03 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |
      | md5('1005') | 1005        | 1993-01-03 | TPCH   |
      | md5('1006') | 1006        | 1993-01-03 | TPCH   |

