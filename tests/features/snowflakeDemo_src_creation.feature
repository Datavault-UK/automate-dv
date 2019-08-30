@test_data
Feature: Source Table Creator
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 19.06.19 CF  1.0     First release.
# 10.07.19 CF  1.1     Updated to test the sql used by dbt. Removal of some scenarios.
# =============================================================================
  @clean_data
  Scenario: Data from TPCH is joined into a table representing the history
    Given there is data in the TPCH sample data
    When I run the sql query to create the source table for the history
    Then the source table must have 58 columns
    And there are no records past the specified date


  Scenario: Data from TPCH is joined into a table for a day load
    Given there is data in the TPCH sample data
    When I run the sql query to create the source table for the day
    Then the source table must have 58 columns
    And there no records past the day1 date

#  Scenario: Data from TPCH is joined into a flat file view for day2 load
#    Given there is data in the TPCH sample data
#    When I run the sql query to create the day2 flat file
#    Then the day2 flat file must have 57 columns
#    And there are only records between the day2 date and history date
#
#   Scenario: Data from TPCH is joined into a flat file view for day3 load
#    Given there is data in the TPCH sample data
#    When I run the sql query to create the day3 flat file
#    Then the day3 flat file must have 57 columns
#    And there are only records between the day3 date and history date