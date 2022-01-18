Feature: [SF-HUB-PARALLEL] Hubs Loaded using duplicate parallel loads, and either default incremental or merge incremental materialisation

  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-01] Load of mixed stage data into an non-existent hub; load by a single process and
  default incremental materialisation
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
    When I load the HUB hub with default incremental materialisation using 1 process and delay 0
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-02] Load of mixed stage data into an non-existent hub; load simultaneously by two processes and
  default incremental materialisation: duplicate records are inserted
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
    When I load the HUB hub with default incremental materialisation using 2 processes and delay 0
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-03] Load of mixed stage data into an non-existent hub; load simultaneously by three processes and
  default incremental materialisation: duplicate records are inserted
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
    When I load the HUB hub with default incremental materialisation using 3 processes and delay 0
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-04] Load of mixed stage data into an non-existent hub; single parallel incremental load
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 1 process and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub with merge incremental materialisation using 1 process and delay 0
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-05] Load of mixed stage data into an non-existent hub; two parallel incremental loads
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-06] Load of mixed stage data into an non-existent hub; two parallel incremental loads with short delay
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0.1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0.1
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-07] Load of mixed stage data into an non-existent hub; two parallel incremental loads with longer delay
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 1
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-08] Load of mixed stage data into an empty hub; two parallel incremental loads
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-09] Load of mixed stage data into an empty hub; two parallel incremental loads and short delay
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0.1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0.1
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-10] Load of mixed stage data into an empty hub; two parallel incremental loads and longer delay
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 1
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-11] Load of mixed stage data into an existing hub; two parallel incremental loads
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-12] Load of mixed stage data into an existing hub; two parallel incremental loads and short delay
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 0.1
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-13] Load of mixed stage data into an existing hub; two parallel incremental loads and longer delay
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 2 processes and delay 1
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |


  @fixture.single_source_hub
  Scenario: [SF-HUB-PARA-14] Load of mixed stage data into an existing hub; multiple parallel incremental loads
  mixing things up a little
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 11 processes and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-03 | TPCH   |
      | 1005        | Eddie         | 1993-01-03 | TPCH   |
      | 1006        | Flora         | 1993-01-03 | TPCH   |
      | 1007        | Gareth        | 1993-01-03 | TPCH   |
      | 1008        | Hannah        | 1993-01-03 | TPCH   |
      | 1009        | Iain          | 1993-01-03 | TPCH   |
      | 1010        | Jemima        | 1993-01-03 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I load the HUB hub with merge incremental materialisation using 9 processes and delay 0.001
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |
      | md5('1005') | 1005        | 1993-01-03 | TPCH   |
      | md5('1006') | 1006        | 1993-01-03 | TPCH   |
      | md5('1007') | 1007        | 1993-01-03 | TPCH   |
      | md5('1008') | 1008        | 1993-01-03 | TPCH   |
      | md5('1009') | 1009        | 1993-01-03 | TPCH   |
      | md5('1010') | 1010        | 1993-01-03 | TPCH   |
