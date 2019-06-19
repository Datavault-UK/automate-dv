@test_data
Feature: Source Table Creator
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 19.06.19 CF  1.0     First release.
# =============================================================================
  @clean_data
  Scenario: Data From TPCH is joined into a history flat file view
    Given there is data in the TPCH sample data
    When I run the sql query to create the history flat file
    Then the history flat file must have 57 columns
    And there are no records past the specified date
