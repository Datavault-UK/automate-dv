Feature: Hubs

  Scenario: Simple load of stage data into an empty hub
    Given the HUB table does not exist
    And the STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_ID | LOADDATE   | SOURCE |
      | 1001        | Alice       | 1993-01-01 | TPCH   |
      | 1001        | Alice       | 1993-01-01 | TPCH   |
      | 1002        | Bob         | 1993-01-01 | TPCH   |
      | 1002        | Bob         | 1993-01-01 | TPCH   |
      | 1002        | Bob         | 1993-01-01 | TPCH   |
      | 1003        | Chad        | 1993-01-01 | TPCH   |
      | 1004        | Dom         | 1993-01-01 | TPCH   |
    When I load the HUB table
    Then the HUB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |