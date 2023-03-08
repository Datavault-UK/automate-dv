Feature: [HUB-PM] Hubs Loaded using Period Materialization

  @fixture.single_source_hub
  Scenario: [HUB-PM-01] Simple load of stage data into an empty hub
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
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |

  @fixture.enable_full_refresh
  @fixture.single_source_hub
  Scenario: [HUB-PM-02] Full refresh of loaded hub
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chloe         | 1995-01-02   | 1993-01-02 | TPCH   |
      | 1004        | Daniel        | 1984-01-01   | 1993-01-02 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |

  @fixture.multi_source_hub
  Scenario: [HUB-PM-03] Simple load of stage data from multiple sources into an empty hub
    Given the HUB table does not exist
    And the RAW_STAGE_PARTS table contains data
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOAD_DATE  | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | *      |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | *      |
    And I stage the STG_PARTS data
    And the RAW_STAGE_SUPPLIER table contains data
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOAD_DATE  | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | *      |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | *      |
    And I stage the STG_SUPPLIER data
    And the RAW_STAGE_LINEITEM table contains data
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOAD_DATE  | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | *      |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | *      |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-03 | *      |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-04 | *      |
    And I stage the STG_LINEITEM data
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | PART_PK     | PART_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-03 | *      |
      | md5('1004') | 1004    | 1993-01-04 | *      |

  @fixture.single_source_hub
  Scenario: [HUB-PM-04] Incremental load by period, of stage data into an empty hub
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
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1005        | Bart          | 1993-01-05 | TPCH   |
      | 1006        | Craig         | 1993-01-06 | TPCH   |
      | 1007        | Amanda        | 1993-01-07 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-01-05 | TPCH   |
      | md5('1006') | 1006        | 1993-01-06 | TPCH   |
      | md5('1007') | 1007        | 1993-01-07 | TPCH   |

  @not_bigquery
  @not_databricks
  @not_postgres
  @fixture.single_source_hub
  Scenario: [HUB-PM-05] Incremental load by period, of stage data into an empty hub with custom database for target
    Given the HUB table does not exist
      """
      database: DBTVAULT_TEST
      """
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-04 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
      """
      database: DBTVAULT_TEST
      """
    And I insert by period into the HUB hub by day
      """
      database: DBTVAULT_TEST
      """
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1005        | Bart          | 1993-01-05 | TPCH   |
      | 1006        | Craig         | 1993-01-06 | TPCH   |
      | 1007        | Amanda        | 1993-01-07 | TPCH   |
    And I stage the STG_CUSTOMER data
    And I insert by period into the HUB hub by day
      """
      database: DBTVAULT_TEST
      """
    And I insert by period into the HUB hub by day
      """
      database: DBTVAULT_TEST
      """
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-01-05 | TPCH   |
      | md5('1006') | 1006        | 1993-01-06 | TPCH   |
      | md5('1007') | 1007        | 1993-01-07 | TPCH   |

  @bigquery
  @fixture.single_source_hub
  Scenario: [HUB-PM-05-BQ] Incremental load by period, of stage data into an empty hub with custom database for target
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
      """
      database: dbtvault-test
      """
    And I stage the STG_CUSTOMER data
      """
      database: dbtvault-test
      """
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1005        | Bart          | 1993-01-05 | TPCH   |
      | 1006        | Craig         | 1993-01-06 | TPCH   |
      | 1007        | Amanda        | 1993-01-07 | TPCH   |
      """
      database: dbtvault-test
      """
    And I stage the STG_CUSTOMER data
      """
      database: dbtvault-test
      """
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-01-05 | TPCH   |
      | md5('1006') | 1006        | 1993-01-06 | TPCH   |
      | md5('1007') | 1007        | 1993-01-07 | TPCH   |

  @databricks
  @fixture.single_source_hub
  Scenario: [HUB-PM-05-DB] Incremental load by period, of stage data into an empty hub with custom schema for target
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
      """
      schema: dbtvault_test
      """
    And I stage the STG_CUSTOMER data
      """
      schema: dbtvault_test
      """
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1005        | Bart          | 1993-01-05 | TPCH   |
      | 1006        | Craig         | 1993-01-06 | TPCH   |
      | 1007        | Amanda        | 1993-01-07 | TPCH   |
      """
      schema: dbtvault_test
      """
    And I stage the STG_CUSTOMER data
      """
      schema: dbtvault_test
      """
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-01-05 | TPCH   |
      | md5('1006') | 1006        | 1993-01-06 | TPCH   |
      | md5('1007') | 1007        | 1993-01-07 | TPCH   |

  @not_bigquery
  @not_databricks
  @not_postgres
  @fixture.single_source_hub
  Scenario: [HUB-PM-06] Incremental load by period, of stage data into an empty hub with custom database for source
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
      """
      database: DBTVAULT_TEST
      """
    And I stage the STG_CUSTOMER data
      """
      database: DBTVAULT_TEST
      """
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1005        | Bart          | 1993-01-05 | TPCH   |
      | 1006        | Craig         | 1993-01-06 | TPCH   |
      | 1007        | Amanda        | 1993-01-07 | TPCH   |
      """
      database: DBTVAULT_TEST
      """
    And I stage the STG_CUSTOMER data
      """
      database: DBTVAULT_TEST
      """
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-01-05 | TPCH   |
      | md5('1006') | 1006        | 1993-01-06 | TPCH   |
      | md5('1007') | 1007        | 1993-01-07 | TPCH   |

  @bigquery
  @fixture.single_source_hub
  Scenario: [HUB-PM-06-BQ] Incremental load by period, of stage data into an empty hub with custom database for source
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
      """
      database: dbtvault-test
      """
    And I stage the STG_CUSTOMER data
      """
      database: dbtvault-test
      """
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1005        | Bart          | 1993-01-05 | TPCH   |
      | 1006        | Craig         | 1993-01-06 | TPCH   |
      | 1007        | Amanda        | 1993-01-07 | TPCH   |
      """
      database: dbtvault-test
      """
    And I stage the STG_CUSTOMER data
      """
      database: dbtvault-test
      """
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-01-05 | TPCH   |
      | md5('1006') | 1006        | 1993-01-06 | TPCH   |
      | md5('1007') | 1007        | 1993-01-07 | TPCH   |

  @databricks
  @fixture.single_source_hub
  Scenario: [HUB-PM-06-DB] Incremental load by period, of stage data into an empty hub with custom database for source
    Given the dbtvault_test_databricks schema does not exist
    And the HUB table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-04 | TPCH   |
      """
      schema: dbtvault_test
      """
    And I stage the STG_CUSTOMER data
      """
      schema: dbtvault_test
      """
    And I insert by period into the HUB hub by day
    And I insert by period into the HUB hub by day
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1005        | Bart          | 1993-01-05 | TPCH   |
      | 1006        | Craig         | 1993-01-06 | TPCH   |
      | 1007        | Amanda        | 1993-01-07 | TPCH   |
      """
      schema: dbtvault_test
      """
    And I stage the STG_CUSTOMER data
      """
      schema: dbtvault_test
      """
    And I insert by period into the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-02 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-01-05 | TPCH   |
      | md5('1006') | 1006        | 1993-01-06 | TPCH   |
      | md5('1007') | 1007        | 1993-01-07 | TPCH   |

  @fixture.single_source_hub
  Scenario: [HUB-PM-07] Simple load of stage data into a non existent hub with millisecond time period
        This will fail with a max iterations error message
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
    And I stage the STG_CUSTOMER data
    Then if I insert by period into the HUB hub by millisecond this will fail with "Max iterations" error

  @fixture.single_source_hub
  Scenario: [HUB-PM-08] Simple load of stage data into an empty hub with millisecond time period
        This will fail with a max iterations error message
    Given the HUB hub is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 1993-01-04 | TPCH   |
    And I stage the STG_CUSTOMER data
    Then if I insert by period into the HUB hub by millisecond this will fail with "Max iterations" error
