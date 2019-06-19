@test_data
Feature: Loads Hubs
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 18.06.19 CF  1.0     First release.
# =============================================================================
  @clean_data
  Scenario: Distinct data from stage is loaded into an empty hub
    Given there is an empty HUB_CUSTOMER table
    And there are records in the V_STG_CUSTOMER view
      | CUSTOMER_PK           | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5_binary('1388608') | 1388608     | 1993-01-02 | TPCH   |
      | md5_binary('1244606') | 1244606     | 1993-01-02 | TPCH   |
      | md5_binary('851140')  | 851140      | 1993-01-02 | TPCH   |
      | md5_binary('592927')  | 592927      | 1993-01-02 | TPCH   |
      | md5_binary('1388608') | 1388608     | 1993-01-02 | TPCH   |
    When I run the snowflakeDemonstrator
    Then the records from V_STG_CUSTOMER should have been inserted into HUB_CUSTOMER
      | CUSTOMER_PK    | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1388608') | 1388608     | 1993-01-02 | TPCH   |
      | md5('1244606') | 1244606     | 1993-01-02 | TPCH   |
      | md5('851140')  | 851140      | 1993-01-02 | TPCH   |
      | md5('592927')  | 592927      | 1993-01-02 | TPCH   |