@fixture.set_workdir
Feature: Hubs Loaded using Period Materialization

  @fixture.single_source_hub
  Scenario: [BASE-PERIOD-MAT] Simple load of stage data into an empty hub
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
    And I hash the stage
    And I use insert_by_period to load the HUB hub by day
    And I use insert_by_period to load the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |

  @fixture.multi_source_hub
  Scenario: [BASE-UNION-PERIOD-MAT] Simple load of stage data from multiple sources into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
    And I hash the stage
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
    And I hash the stage
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-03 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-04 | LINE   |
    And I hash the stage
    And I use insert_by_period to load the HUB hub by day
    And I use insert_by_period to load the HUB hub by day
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-03 | *      |
      | md5('1004') | 1004    | 1993-01-04 | *      |