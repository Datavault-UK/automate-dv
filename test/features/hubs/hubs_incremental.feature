Feature: [HUB-IM] Hubs Loaded using Incremental Materialization

  @fixture.single_source_hub
  Scenario: [HUB-IM-01] Load of empty stage into an non-existent hub - one cycle
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
  Scenario: [HUB-IM-02] Load of mixed stage data into an non-existent hub - one cycle
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
  Scenario: [HUB-IM-03] Load of mixed stage data into an non-existent hub - two cycles
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
  Scenario: [HUB-IM-04] Load of empty stage data into an empty hub - two cycles
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
  Scenario: [HUB-IM-05] Load of stage data into an empty hub - one cycle
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
  Scenario: [HUB-IM-06] Load of mixed stage data into an empty hub - two cycles
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
  Scenario: [HUB-IM-07] Load of empty stage data into a populated hub - one cycle
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
  Scenario: [HUB-IM-08] Load of mixed stage data into a populated hub - one cycle
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
  Scenario: [HUB-IM-09] Load of mixed stage data into a populated hub - two cycles
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

  @fixture.single_source_hub
  Scenario: [HUB-IM-10] Load of empty stage into an non-existent hub with additional columns - one cycle
    Given the HUB_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB_AC hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the HUB_AC hub
    Then the HUB_AC table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-IM-11] Load of empty stage data into an empty hub with additional columns - one cycle
    Given the HUB_AC hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB_AC hub
    Then the HUB_AC table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-IM-11] Load of empty stage data into an empty hub with additional columns - two cycles
    Given the HUB_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | 1002        | Bob           | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB_AC hub
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
      | 1004        | Dom           | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB_AC hub
    Then the HUB_AC table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-IM-12] Load of mixed stage data into a populated hub with additional columns - one cycle
    Given the HUB_AC hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
      | 1002        | Bobby         | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
      | 1003        | Chad          | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
      | 1004        | Dom           | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB_AC hub
    Then the HUB_AC table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | TPCH_CUSTOMER  | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | TPCH_CUSTOMER  | 1993-01-02 | TPCH   |
