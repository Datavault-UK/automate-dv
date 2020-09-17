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


  @fixture.single_source_hub
  Scenario: [POPULATED-LOAD-PERIOD-MAT-DAY] Keys with NULL or empty values are not loaded into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-04 | TPCH   |
      | <null>      | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
      |             | Chad          | 2018-04-13   | 1993-01-02 | TPCH   |
    And I hash the stage
    And I use insert_by_period to load the HUB hub by day
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |

  @fixture.single_source_hub
  Scenario: [POPULATED-LOAD-PERIOD-MAT-MONTH] Keys with NULL or empty values are not loaded into a hub
    Given the HUB hub is already populated with data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-03 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-04 | TPCH   |
      | <null>      | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
      |             | Chad          | 2018-04-13   | 1993-01-02 | TPCH   |
      | 1005        | Emily         | 2002-04-13   | 1993-02-04 | TPCH   |
    And I hash the stage
    And I use insert_by_period to load the HUB hub by month
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-03 | TPCH   |
      | md5('1004') | 1004        | 1993-01-04 | TPCH   |
      | md5('1005') | 1005        | 1993-02-04 | TPCH   |