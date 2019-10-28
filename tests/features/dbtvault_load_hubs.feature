@test_data
@clean_data
Feature: Load Hubs
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 18.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# 24.09.19 NS  1.2     Reviewed and cleaned up. Test one thing per test.
# =============================================================================

# -----------------------------------------------------------------------------
# Testing insertion of records into a hub which doesn't yet exist
# -----------------------------------------------------------------------------
    Scenario: [BASE-LOAD-SINGLE] Simple load of stage data into an empty hub
    Given a TEST_HUB_CUSTOMER_HUBS table does not exist
    And there are records in the TEST_STG_CUSTOMER table
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    When I load the TEST_HUB_CUSTOMER_HUBS table
    Then the TEST_HUB_CUSTOMER table should contain
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

    Scenario: [BASE-LOAD-SINGLE] Simple load of distinct stage data into an empty hub
    Given a TEST_HUB_CUSTOMER_HUBS table does not exist
    And there are records in the TEST_STG_CUSTOMER table
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    When I load the TEST_HUB_CUSTOMER_HUBS table
    Then the TEST_HUB_CUSTOMER table should contain
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

# -----------------------------------------------------------------------------
# Testing insertion of records into an empty hub, i.e. initial load.
# -----------------------------------------------------------------------------
  Scenario: [SINGLE-SOURCE] Simple load of stage data into an empty hub
    Given there is an empty TEST_HUB_CUSTOMER table
    And there are records in the TEST_STG_CUSTOMER table
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    When I load the TEST_HUB_CUSTOMER table
    Then the TEST_HUB_CUSTOMER table should contain
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: [SINGLE-SOURCE] Simple load of distinct stage data into an empty hub
    Given there is an empty TEST_HUB_CUSTOMER table
    And there are records in the TEST_STG_CUSTOMER table
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-01 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-01 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-01 | TPCH   |
    When I load the TEST_HUB_CUSTOMER table
    Then the TEST_HUB_CUSTOMER table should contain
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

# -----------------------------------------------------------------------------
# Testing insertion of records into a hub with data already populated from
# previous load cycles.
# -----------------------------------------------------------------------------
  Scenario: [SINGLE-SOURCE] Load of stage data into a hub
    Given there are records in the TEST_HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And there are records in the TEST_STG_CUSTOMER table
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    When I load the TEST_HUB_CUSTOMER table
    Then the TEST_HUB_CUSTOMER table should contain
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

  Scenario: [SINGLE-SOURCE] Load of distinct stage data into a hub
    Given there are records in the TEST_HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And there are records in the TEST_STG_CUSTOMER table
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1001        | Alice         | 1997-04-24   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1002        | Bob           | 2006-04-17   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1003        | Chad          | 2013-02-04   | 1993-01-02 | TPCH   |
      | 1004        | Dom           | 2018-04-13   | 1993-01-02 | TPCH   |
    When I load the TEST_HUB_CUSTOMER table
    Then the TEST_HUB_CUSTOMER table should contain
      | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-02 | TPCH   |
      | md5('1004') | 1004        | 1993-01-02 | TPCH   |

# -----------------------------------------------------------------------------------------
# Test union of different staging tables to insert records into hubs which don't yet exist
# -----------------------------------------------------------------------------------------

    Scenario: [BASE-LOAD-UNION] Union three staging tables to feed a empty hub which doesn't yet exist.
    Given a TEST_HUB_PARTS table does not exist
    And there are records in the TEST_STG_PARTS table
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
    And there are records in the TEST_STG_SUPPLIER table
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
    And there are records in the TEST_STG_LINEITEM table
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | LINE   |
    And I load the TEST_HUB_PARTS table
    Then the TEST_HUB_PARTS table should contain
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-01 | *      |
      | md5('1004') | 1004    | 1993-01-01 | *      |
      | md5('1005') | 1005    | 1993-01-01 | *      |
      | md5('1006') | 1006    | 1993-01-01 | *      |

# -----------------------------------------------------------------------------
# Test union of different staging tables to insert records into an empty hub.
# -----------------------------------------------------------------------------

  Scenario: [UNION] Union three staging tables to feed an empty hub.
    Given there is an empty TEST_HUB_PARTS table
    And there are records in the TEST_STG_PARTS table
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-01 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-01 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-01 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-01 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-01 | PART   |
    And there are records in the TEST_STG_SUPPLIER table
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-01 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-01 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-01 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-01 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-01 | SUPP   |
    And there are records in the TEST_STG_LINEITEM table
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-01 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-01 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-01 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-01 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-01 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-01 | LINE   |
    And I load the TEST_HUB_PARTS table
    Then the TEST_HUB_PARTS table should contain
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-01 | *      |
      | md5('1004') | 1004    | 1993-01-01 | *      |
      | md5('1005') | 1005    | 1993-01-01 | *      |
      | md5('1006') | 1006    | 1993-01-01 | *      |

    Scenario: [UNION] Union three staging tables to feed an empty hub over two cycles.
    Given there are records in the TEST_HUB_PARTS table
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
    And there are records in the TEST_STG_PARTS table
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
    And there are records in the TEST_STG_SUPPLIER table
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
    And there are records in the TEST_STG_LINEITEM table
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | LINE   |
    And I load the TEST_HUB_PARTS table
    And there are records in the TEST_STG_PARTS table
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-03 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-03 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-03 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-03 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-03 | PART   |
    And there are records in the TEST_STG_SUPPLIER table
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 5        | 68.00      | 1993-01-03 | SUPP   |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | SUPP   |
      | 1002    | 1           | 13       | 110.00     | 1993-01-03 | SUPP   |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | SUPP   |
      | 1002    | 1           | 0        | 120.00     | 1993-01-03 | SUPP   |
    And there are records in the TEST_STG_LINEITEM table
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10007    | 1007    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-03 | LINE   |
      | 10007    | 1007    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-03 | LINE   |
      | 10008    | 1008    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-03 | LINE   |
      | 10008    | 1008    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-03 | LINE   |
      | 10009    | 1009    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-03 | LINE   |
    When I load the TEST_HUB_PARTS table
    Then the TEST_HUB_PARTS table should contain
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-02 | *      |
      | md5('1004') | 1004    | 1993-01-02 | *      |
      | md5('1005') | 1005    | 1993-01-02 | *      |
      | md5('1006') | 1006    | 1993-01-02 | *      |
      | md5('1007') | 1007    | 1993-01-03 | *      |
      | md5('1008') | 1008    | 1993-01-03 | *      |
      | md5('1009') | 1009    | 1993-01-03 | *      |

# -----------------------------------------------------------------------------
# Test union of different staging tables to insert records into a hub with
# existing records.
# -----------------------------------------------------------------------------
  Scenario: [UNION] Union three staging tables to feed a populated hub.
    Given there are records in the TEST_HUB_PARTS table
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
    And there are records in the TEST_STG_PARTS table
      | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
      | 1001    | Pedal     | internal  | M         | 60.00            | 1993-01-02 | PART   |
      | 1002    | Door      | external  | XL        | 150.00           | 1993-01-02 | PART   |
      | 1003    | Seat      | internal  | R         | 27.68            | 1993-01-02 | PART   |
      | 1004    | Aerial    | external  | S         | 10.40            | 1993-01-02 | PART   |
      | 1005    | Cover     | other     | L         | 1.50             | 1993-01-02 | PART   |
    And there are records in the TEST_STG_SUPPLIER table
      | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
      | 1001    | 9           | 6        | 68.00      | 1993-01-02 | SUPP   |
      | 1002    | 1           | 2        | 120.00     | 1993-01-02 | SUPP   |
      | 1003    | 1           | 1        | 29.87      | 1993-01-02 | SUPP   |
      | 1004    | 6           | 3        | 101.40     | 1993-01-02 | SUPP   |
      | 1005    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
      | 1006    | 7           | 8        | 10.50      | 1993-01-02 | SUPP   |
    And there are records in the TEST_STG_LINEITEM table
      | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
      | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 1993-01-02 | LINE   |
      | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 1993-01-02 | LINE   |
      | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 1993-01-02 | LINE   |
      | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 1993-01-02 | LINE   |
      | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 1993-01-02 | LINE   |
      | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 1993-01-02 | LINE   |
    When I load the TEST_HUB_PARTS table
    Then the TEST_HUB_PARTS table should contain
      | PART_PK     | PART_ID | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | *      |
      | md5('1002') | 1002    | 1993-01-01 | *      |
      | md5('1003') | 1003    | 1993-01-02 | *      |
      | md5('1004') | 1004    | 1993-01-02 | *      |
      | md5('1005') | 1005    | 1993-01-02 | *      |
      | md5('1006') | 1006    | 1993-01-02 | *      |
