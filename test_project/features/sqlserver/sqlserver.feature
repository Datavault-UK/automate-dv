@fixture.set_workdir
Feature: sqlserver

  @fixture.single_source_hub_sqlserver
  Scenario: [HUB-BASE-LOAD-1] Simple load of stage data into an empty hub, PK is a hash of a single column
    Given the HUB_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I create the STG_CUSTOMER stage
    When I load the HUB_CUSTOMER hub
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  @fixture.single_source_hub_sqlserver
  Scenario: [HUB-BASE-LOAD-2] Simple load of stage data into an empty hub, PK is a hash of a list of columns
    Given the HUB_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I create the STG_CUSTOMER_HASHLIST stage
    When I load the HUB_CUSTOMER hub
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK          | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001\|\|ALICE') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002\|\|BOB')   | 1002        | 1993-01-01 | TPCH   |
      | md5('1003\|\|CHAD')  | 1003        | 1993-01-01 | TPCH   |
      | md5('1004\|\|DOM')   | 1004        | 1993-01-01 | TPCH   |
