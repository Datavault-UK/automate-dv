Feature: [HUB-CK] Hubs - Collision Keys

  @fixture.single_source_hub_with_collision_key
  Scenario: [HUB-CK-01] Simple load of stage data into an empty hub with collision keys
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |

  @fixture.multi_source_hub_with_collision_key
  Scenario: [HUB-CK-02] Simple load of identical stage data from multiple sources into an empty hub with collision keys
    Given the HUB table does not exist
    And the RAW_STAGE_A table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_A data
    And the RAW_STAGE_B table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_B data
    And the RAW_STAGE_C table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 1993-01-01 | TPCH   |
    And I stage the STG_CUSTOMER_C data
    When I load the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK      | CUSTOMER_ID | COLLISION_KEY | LOAD_DATE  | SOURCE |
      | md5('A\|\|1001') | 1001        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1002') | 1002        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1003') | 1003        | A             | 1993-01-01 | TPCH   |
      | md5('A\|\|1004') | 1004        | A             | 1993-01-01 | TPCH   |
      | md5('B\|\|1001') | 1001        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1002') | 1002        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1003') | 1003        | B             | 1993-01-01 | TPCH   |
      | md5('B\|\|1004') | 1004        | B             | 1993-01-01 | TPCH   |
      | md5('C\|\|1001') | 1001        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1002') | 1002        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1003') | 1003        | C             | 1993-01-01 | TPCH   |
      | md5('C\|\|1004') | 1004        | C             | 1993-01-01 | TPCH   |

