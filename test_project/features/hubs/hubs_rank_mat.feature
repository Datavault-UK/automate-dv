@fixture.set_workdir
Feature: Hubs Loaded using Rank Materialization

  @fixture.single_source_hub
  Scenario: [BASE-RANK-MAT] Simple load of stage data into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-04 | TPCH   |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the HUB hub
    And I insert by rank into the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |

  @fixture.enable_full_refresh
  @fixture.single_source_hub
  Scenario: [RANK-BASE] Full refresh of loaded hub
    Given the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chloe         | 1995-01-02   | 1993-01-02 | TPCH   |
      | 1004        | Daniel        | 1984-01-01   | 1993-01-02 | TPCH   |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I create the STG_CUSTOMER stage
    And I insert by rank into the HUB hub
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  @fixture.multi_source_hub
  Scenario: [BASE-UNION-RANK-MAT] Simple load of stage data from multiple sources into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | *      |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_PARTS stage partitioned by PART_ID and ordered by LOAD_DATE
    And I create the STG_PARTS stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | *      |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_SUPPLIER stage partitioned by PART_ID and ordered by LOAD_DATE
    And I create the STG_SUPPLIER stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | *      |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-03 | *      |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_LINEITEM stage partitioned by PART_ID and ordered by LOAD_DATE
    And I create the STG_LINEITEM stage
    And I insert by rank into the HUB hub
    And I insert by rank into the HUB hub
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-03 | *      |
      | md5('1004') | 1004    | 1993-01-04 | *      |