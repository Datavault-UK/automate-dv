Feature: Load Multiperiod Hubs
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------

    Scenario: [BASE-LOAD-SINGLE] Simple load of stage data into an empty hub
      Given a TEST_MULTIPERIOD_HUB_CUSTOMER table does not exist
      And there are records in the TEST_STG_CUSTOMER table
        | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
        | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
        | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
        | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
        | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
        | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
        | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
        | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 1993-01-01 | TPCH   |
        | md5('1002') | 1002        | 1993-01-01 | TPCH   |
        | md5('1003') | 1003        | 1993-01-01 | TPCH   |
        | md5('1004') | 1004        | 1993-01-01 | TPCH   |