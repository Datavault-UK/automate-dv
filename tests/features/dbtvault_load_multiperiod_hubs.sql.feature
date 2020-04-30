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
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1003        | Charley       | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1010        | Ronna         | 1991-03-21   | 2019-05-04 | TPCH   |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1003        | Michael       | 1990-02-03   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-06 | TPCH   |
        | 1003        | Harold        | 1990-02-03   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1006        | Chris         | 1960-01-01   | 2019-05-06 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
        | md5('1004') | 1004        | 2019-05-05 | TPCH   |
        | md5('1005') | 1005        | 2019-05-06 | TPCH   |
        | md5('1006') | 1006        | 2019-05-06 | TPCH   |

    Scenario: [BASE-LOAD-SINGLE] Simple load of distinct stage data into an empty hub
      Given a TEST_MULTIPERIOD_HUB_CUSTOMER table does not exist
      And there are records in the TEST_STG_CUSTOMER table
        | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1003        | Charley       | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1010        | Ronna         | 1991-03-21   | 2019-05-04 | TPCH   |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1003        | Michael       | 1990-02-03   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-06 | TPCH   |
        | 1003        | Harold        | 1990-02-03   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1006        | Chris         | 1960-01-01   | 2019-05-06 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
        | md5('1004') | 1004        | 2019-05-05 | TPCH   |
        | md5('1005') | 1005        | 2019-05-06 | TPCH   |
        | md5('1006') | 1006        | 2019-05-06 | TPCH   |

    Scenario: [BASE-LOAD-SHA] Simple load of distinct stage data into an empty hub using SHA hashing
      Given a TEST_MULTIPERIOD_HUB_CUSTOMER table does not exist
      And there are records in the TEST_STG_CUSTOMER table
        | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1003        | Charley       | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1010        | Ronna         | 1991-03-21   | 2019-05-04 | TPCH   |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1003        | Michael       | 1990-02-03   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-06 | TPCH   |
        | 1003        | Harold        | 1990-02-03   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1006        | Chris         | 1960-01-01   | 2019-05-06 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table using SHA
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | sha('1001') | 1001        | 2019-05-04 | TPCH   |
        | sha('1002') | 1002        | 2019-05-04 | TPCH   |
        | sha('1003') | 1003        | 2019-05-04 | TPCH   |
        | sha('1010') | 1010        | 2019-05-04 | TPCH   |
        | sha('1004') | 1004        | 2019-05-05 | TPCH   |
        | sha('1005') | 1005        | 2019-05-06 | TPCH   |
        | sha('1006') | 1006        | 2019-05-06 | TPCH   |


# -----------------------------------------------------------------------------
# Testing insertion of records into an empty hub, i.e. initial load.
# -----------------------------------------------------------------------------

    Scenario: [SINGLE-SOURCE] Simple load of stage data into an empty hub
      Given there is an empty TEST_MULTIPERIOD_HUB_CUSTOMER table
      And there are records in the TEST_STG_CUSTOMER table
        | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1003        | Charley       | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1010        | Ronna         | 1991-03-21   | 2019-05-04 | TPCH   |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1003        | Michael       | 1990-02-03   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-06 | TPCH   |
        | 1003        | Harold        | 1990-02-03   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1006        | Chris         | 1960-01-01   | 2019-05-06 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
        | md5('1004') | 1004        | 2019-05-05 | TPCH   |
        | md5('1005') | 1005        | 2019-05-06 | TPCH   |
        | md5('1006') | 1006        | 2019-05-06 | TPCH   |

    Scenario: [SINGLE-SOURCE] Simple load of distinct stage data into an empty hub
      Given there is an empty TEST_MULTIPERIOD_HUB_CUSTOMER table
      And there are records in the TEST_STG_CUSTOMER table
        | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1001        | Albert        | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-04 | TPCH   |
        | 1003        | Charley       | 1990-02-03   | 2019-05-04 | TPCH   |
        | 1010        | Ronna         | 1991-03-21   | 2019-05-04 | TPCH   |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1003        | Michael       | 1990-02-03   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-06 | TPCH   |
        | 1003        | Harold        | 1990-02-03   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1006        | Chris         | 1960-01-01   | 2019-05-06 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
        | md5('1004') | 1004        | 2019-05-05 | TPCH   |
        | md5('1005') | 1005        | 2019-05-06 | TPCH   |
        | md5('1006') | 1006        | 2019-05-06 | TPCH   |

# -----------------------------------------------------------------------------
# Testing insertion of records into a hub with data already populated from
# previous load cycles.
# -----------------------------------------------------------------------------

    Scenario: [SINGLE-SOURCE] Load of stage data into a hub
      Given there are records in the TEST_MULTIPERIOD_HUB_CUSTOMER table
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
      And there are records in the TEST_STG_CUSTOMER table
        | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1003        | Michael       | 1990-02-03   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-06 | TPCH   |
        | 1003        | Harold        | 1990-02-03   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1006        | Chris         | 1960-01-01   | 2019-05-06 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
        | md5('1004') | 1004        | 2019-05-05 | TPCH   |
        | md5('1005') | 1005        | 2019-05-06 | TPCH   |
        | md5('1006') | 1006        | 2019-05-06 | TPCH   |

    Scenario: [SINGLE-SOURCE] Load of distinct stage data into a hub
      Given there are records in the TEST_MULTIPERIOD_HUB_CUSTOMER table
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
      And there are records in the TEST_STG_CUSTOMER table
        | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE   | SOURCE |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1002        | Jack          | 1995-08-07   | 2019-05-05 | TPCH   |
        | 1003        | Michael       | 1990-02-03   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1004        | David         | 1992-01-30   | 2019-05-05 | TPCH   |
        | 1002        | Beth          | 1995-08-07   | 2019-05-06 | TPCH   |
        | 1003        | Harold        | 1990-02-03   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1005        | Kevin         | 2001-07-23   | 2019-05-06 | TPCH   |
        | 1006        | Chris         | 1960-01-01   | 2019-05-06 | TPCH   |
      When I load the TEST_MULTIPERIOD_HUB_CUSTOMER table
      Then the TEST_MULTIPERIOD_HUB_CUSTOMER table should contain
        | CUSTOMER_PK | CUSTOMER_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001        | 2019-05-04 | TPCH   |
        | md5('1002') | 1002        | 2019-05-04 | TPCH   |
        | md5('1003') | 1003        | 2019-05-04 | TPCH   |
        | md5('1010') | 1010        | 2019-05-04 | TPCH   |
        | md5('1004') | 1004        | 2019-05-05 | TPCH   |
        | md5('1005') | 1005        | 2019-05-06 | TPCH   |
        | md5('1006') | 1006        | 2019-05-06 | TPCH   |

# -----------------------------------------------------------------------------------------
# Test union of different staging tables to insert records into hubs which don't yet exist
# -----------------------------------------------------------------------------------------

    Scenario: [BASE-LOAD-UNION] Union three staging tables to feed a empty hub which doesn't yet exist.
      Given a TEST_MULTIPERIOD_HUB_PARTS table does not exist
      And there are records in the TEST_STG_PARTS table
        | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-04 | PART   |
        | 1002    | Door      | external  | XL        | 150.00           | 2019-05-04 | PART   |
        | 1003    | Seat      | internal  | R         | 27.68            | 2019-05-04 | PART   |
        | 1004    | Aerial    | external  | S         | 10.40            | 2019-05-04 | PART   |
        | 1005    | Cover     | other     | L         | 1.50             | 2019-05-04 | PART   |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-05 | PART   |
        | 1006    | Door      | external  | XL        | 150.00           | 2019-05-05 | PART   |
        | 1007    | Seat      | internal  | R         | 27.68            | 2019-05-05 | PART   |
        | 1008    | Aerial    | external  | S         | 10.40            | 2019-05-06 | PART   |
        | 1004    | Cover     | other     | L         | 1.50             | 2019-05-06 | PART   |
      And there are records in the TEST_STG_SUPPLIER table
        | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
        | 1001    | 9           | 6        | 68.00      | 2019-05-04 | SUPP   |
        | 1002    | 1           | 2        | 120.00     | 2019-05-04 | SUPP   |
        | 1003    | 1           | 1        | 29.87      | 2019-05-04 | SUPP   |
        | 1004    | 6           | 3        | 101.40     | 2019-05-05 | SUPP   |
        | 1005    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1006    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1009    | 9           | 1        | 10.50      | 2019-05-06 | SUPP   |
      And there are records in the TEST_STG_LINEITEM table
        | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
        | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 2019-05-04 | LINE   |
        | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 2019-05-04 | LINE   |
        | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 2019-05-04 | LINE   |
        | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 2019-05-06 | LINE   |
        | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 2019-05-06 | LINE   |
      And I load the TEST_MULTIPERIOD_HUB_PARTS table
      Then the TEST_MULTIPERIOD_HUB_PARTS table should contain
        | PART_PK     | PART_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001    | 2019-05-04 | *      |
        | md5('1002') | 1002    | 2019-05-04 | *      |
        | md5('1003') | 1003    | 2019-05-04 | *      |
        | md5('1004') | 1004    | 2019-05-04 | *      |
        | md5('1005') | 1005    | 2019-05-04 | *      |
        | md5('1006') | 1006    | 2019-05-05 | *      |
        | md5('1007') | 1007    | 2019-05-05 | *      |
        | md5('1008') | 1008    | 2019-05-06 | *      |
        | md5('1009') | 1009    | 2019-05-06 | *      |

# -----------------------------------------------------------------------------
# Test union of different staging tables to insert records into an empty hub.
# -----------------------------------------------------------------------------

    Scenario: [UNION] Union three staging tables to feed an empty hub.
      Given there is an empty TEST_MULTIPERIOD_HUB_PARTS table
      And there are records in the TEST_STG_PARTS table
        | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-04 | PART   |
        | 1002    | Door      | external  | XL        | 150.00           | 2019-05-04 | PART   |
        | 1003    | Seat      | internal  | R         | 27.68            | 2019-05-04 | PART   |
        | 1004    | Aerial    | external  | S         | 10.40            | 2019-05-04 | PART   |
        | 1005    | Cover     | other     | L         | 1.50             | 2019-05-04 | PART   |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-05 | PART   |
        | 1006    | Door      | external  | XL        | 150.00           | 2019-05-05 | PART   |
        | 1007    | Seat      | internal  | R         | 27.68            | 2019-05-05 | PART   |
        | 1008    | Aerial    | external  | S         | 10.40            | 2019-05-06 | PART   |
        | 1004    | Cover     | other     | L         | 1.50             | 2019-05-06 | PART   |
      And there are records in the TEST_STG_SUPPLIER table
        | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
        | 1001    | 9           | 6        | 68.00      | 2019-05-04 | SUPP   |
        | 1002    | 1           | 2        | 120.00     | 2019-05-04 | SUPP   |
        | 1003    | 1           | 1        | 29.87      | 2019-05-04 | SUPP   |
        | 1004    | 6           | 3        | 101.40     | 2019-05-05 | SUPP   |
        | 1005    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1006    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1009    | 9           | 1        | 10.50      | 2019-05-06 | SUPP   |
      And there are records in the TEST_STG_LINEITEM table
        | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
        | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 2019-05-04 | LINE   |
        | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 2019-05-04 | LINE   |
        | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 2019-05-04 | LINE   |
        | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 2019-05-06 | LINE   |
        | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 2019-05-06 | LINE   |
      And I load the TEST_MULTIPERIOD_HUB_PARTS table
      Then the TEST_MULTIPERIOD_HUB_PARTS table should contain
        | PART_PK     | PART_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001    | 2019-05-04 | *      |
        | md5('1002') | 1002    | 2019-05-04 | *      |
        | md5('1003') | 1003    | 2019-05-04 | *      |
        | md5('1004') | 1004    | 2019-05-04 | *      |
        | md5('1005') | 1005    | 2019-05-04 | *      |
        | md5('1006') | 1006    | 2019-05-05 | *      |
        | md5('1007') | 1007    | 2019-05-05 | *      |
        | md5('1008') | 1008    | 2019-05-06 | *      |
        | md5('1009') | 1009    | 2019-05-06 | *      |

    Scenario: [UNION] Union three staging tables to feed an empty hub over two cycles.
      Given there is an empty TEST_MULTIPERIOD_HUB_PARTS table
      And there are records in the TEST_STG_PARTS table
        | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-04 | PART   |
        | 1002    | Door      | external  | XL        | 150.00           | 2019-05-04 | PART   |
        | 1003    | Seat      | internal  | R         | 27.68            | 2019-05-04 | PART   |
        | 1004    | Aerial    | external  | S         | 10.40            | 2019-05-04 | PART   |
        | 1005    | Cover     | other     | L         | 1.50             | 2019-05-04 | PART   |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-05 | PART   |
        | 1006    | Door      | external  | XL        | 150.00           | 2019-05-05 | PART   |
        | 1007    | Seat      | internal  | R         | 27.68            | 2019-05-05 | PART   |
        | 1008    | Aerial    | external  | S         | 10.40            | 2019-05-06 | PART   |
        | 1004    | Cover     | other     | L         | 1.50             | 2019-05-06 | PART   |
      And there are records in the TEST_STG_SUPPLIER table
        | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
        | 1001    | 9           | 6        | 68.00      | 2019-05-04 | SUPP   |
        | 1002    | 1           | 2        | 120.00     | 2019-05-04 | SUPP   |
        | 1003    | 1           | 1        | 29.87      | 2019-05-04 | SUPP   |
        | 1004    | 6           | 3        | 101.40     | 2019-05-05 | SUPP   |
        | 1005    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1006    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1009    | 9           | 1        | 10.50      | 2019-05-06 | SUPP   |
      And there are records in the TEST_STG_LINEITEM table
        | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
        | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 2019-05-04 | LINE   |
        | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 2019-05-04 | LINE   |
        | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 2019-05-04 | LINE   |
        | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 2019-05-06 | LINE   |
        | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 2019-05-06 | LINE   |
      And I load the TEST_MULTIPERIOD_HUB_PARTS table
      And there are records in the TEST_STG_PARTS table
        | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-07 | PART   |
        | 1002    | Door      | external  | XL        | 150.00           | 2019-05-07 | PART   |
        | 1003    | Seat      | internal  | R         | 27.68            | 2019-05-07 | PART   |
        | 1004    | Aerial    | external  | S         | 10.40            | 2019-05-07 | PART   |
        | 1005    | Cover     | other     | L         | 1.50             | 2019-05-07 | PART   |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-08 | PART   |
        | 1006    | Door      | external  | XL        | 150.00           | 2019-05-08 | PART   |
        | 1007    | Seat      | internal  | R         | 27.68            | 2019-05-08 | PART   |
        | 1008    | Aerial    | external  | S         | 10.40            | 2019-05-09 | PART   |
        | 1004    | Cover     | other     | L         | 1.50             | 2019-05-09 | PART   |
      And there are records in the TEST_STG_SUPPLIER table
        | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
        | 1001    | 9           | 6        | 68.00      | 2019-05-07 | SUPP   |
        | 1002    | 1           | 2        | 120.00     | 2019-05-07 | SUPP   |
        | 1003    | 1           | 1        | 29.87      | 2019-05-07 | SUPP   |
        | 1004    | 6           | 3        | 101.40     | 2019-05-08 | SUPP   |
        | 1005    | 7           | 8        | 10.50      | 2019-05-08 | SUPP   |
        | 1006    | 7           | 8        | 10.50      | 2019-05-08 | SUPP   |
        | 1009    | 9           | 1        | 10.50      | 2019-05-09 | SUPP   |
      And there are records in the TEST_STG_LINEITEM table
        | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
        | 10010    | 1010    | 9           | 1          | 6        | 168.00         | 18.00    | 2019-05-07 | LINE   |
        | 10010    | 1010    | 9           | 2          | 7        | 169.00         | 18.00    | 2019-05-08 | LINE   |
        | 10011    | 1011    | 9           | 3          | 8        | 175.00         | 18.00    | 2019-05-08 | LINE   |
        | 10011    | 1011    | 11          | 1          | 2        | 10.00          | 1.00     | 2019-05-08 | LINE   |
        | 10012    | 1012    | 11          | 1          | 1        | 290.87         | 2.00     | 2019-05-09 | LINE   |
      When I load the TEST_MULTIPERIOD_HUB_PARTS table
      Then the TEST_MULTIPERIOD_HUB_PARTS table should contain
        | PART_PK     | PART_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001    | 2019-05-04 | *      |
        | md5('1002') | 1002    | 2019-05-04 | *      |
        | md5('1003') | 1003    | 2019-05-04 | *      |
        | md5('1004') | 1004    | 2019-05-04 | *      |
        | md5('1005') | 1005    | 2019-05-04 | *      |
        | md5('1006') | 1006    | 2019-05-05 | *      |
        | md5('1007') | 1007    | 2019-05-05 | *      |
        | md5('1008') | 1008    | 2019-05-06 | *      |
        | md5('1009') | 1009    | 2019-05-06 | *      |
        | md5('1010') | 1010    | 2019-05-07 | *      |
        | md5('1011') | 1011    | 2019-05-08 | *      |
        | md5('1012') | 1012    | 2019-05-09 | *      |

# -----------------------------------------------------------------------------
# Test union of different staging tables to insert records into a hub with
# existing records.
# -----------------------------------------------------------------------------

    Scenario: [UNION] Union three staging tables to feed a populated hub.
      Given there are records in the TEST_MULTIPERIOD_HUB_PARTS table
        | PART_PK     | PART_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001    | 2019-05-03 | *      |
        | md5('1002') | 1002    | 2019-05-03 | *      |
      And there are records in the TEST_STG_PARTS table
        | PART_ID | PART_NAME | PART_TYPE | PART_SIZE | PART_RETAILPRICE | LOADDATE   | SOURCE |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-04 | PART   |
        | 1002    | Door      | external  | XL        | 150.00           | 2019-05-04 | PART   |
        | 1003    | Seat      | internal  | R         | 27.68            | 2019-05-04 | PART   |
        | 1004    | Aerial    | external  | S         | 10.40            | 2019-05-04 | PART   |
        | 1005    | Cover     | other     | L         | 1.50             | 2019-05-04 | PART   |
        | 1001    | Pedal     | internal  | M         | 60.00            | 2019-05-05 | PART   |
        | 1006    | Door      | external  | XL        | 150.00           | 2019-05-05 | PART   |
        | 1007    | Seat      | internal  | R         | 27.68            | 2019-05-05 | PART   |
        | 1008    | Aerial    | external  | S         | 10.40            | 2019-05-06 | PART   |
        | 1004    | Cover     | other     | L         | 1.50             | 2019-05-06 | PART   |
      And there are records in the TEST_STG_SUPPLIER table
        | PART_ID | SUPPLIER_ID | AVAILQTY | SUPPLYCOST | LOADDATE   | SOURCE |
        | 1001    | 9           | 6        | 68.00      | 2019-05-04 | SUPP   |
        | 1002    | 1           | 2        | 120.00     | 2019-05-04 | SUPP   |
        | 1003    | 1           | 1        | 29.87      | 2019-05-04 | SUPP   |
        | 1004    | 6           | 3        | 101.40     | 2019-05-05 | SUPP   |
        | 1005    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1006    | 7           | 8        | 10.50      | 2019-05-05 | SUPP   |
        | 1009    | 9           | 1        | 10.50      | 2019-05-06 | SUPP   |
      And there are records in the TEST_STG_LINEITEM table
        | ORDER_ID | PART_ID | SUPPLIER_ID | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | SOURCE |
        | 10001    | 1001    | 9           | 1          | 6        | 168.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1002    | 9           | 2          | 7        | 169.00         | 18.00    | 2019-05-04 | LINE   |
        | 10001    | 1003    | 9           | 3          | 8        | 175.00         | 18.00    | 2019-05-04 | LINE   |
        | 10002    | 1002    | 11          | 1          | 2        | 10.00          | 1.00     | 2019-05-04 | LINE   |
        | 10003    | 1003    | 11          | 1          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10003    | 1004    | 1           | 2          | 1        | 290.87         | 2.00     | 2019-05-04 | LINE   |
        | 10004    | 1004    | 6           | 1          | 3        | 10.40          | 5.50     | 2019-05-04 | LINE   |
        | 10004    | 1005    | 1           | 2          | 3        | 10.40          | 5.50     | 2019-05-06 | LINE   |
        | 10005    | 1005    | 7           | 1          | 8        | 106.50         | 21.10    | 2019-05-06 | LINE   |
      When I load the TEST_MULTIPERIOD_HUB_PARTS table
      Then the TEST_MULTIPERIOD_HUB_PARTS table should contain
        | PART_PK     | PART_ID | LOADDATE   | SOURCE |
        | md5('1001') | 1001    | 2019-05-03 | *      |
        | md5('1002') | 1002    | 2019-05-03 | *      |
        | md5('1003') | 1003    | 2019-05-04 | *      |
        | md5('1004') | 1004    | 2019-05-04 | *      |
        | md5('1005') | 1005    | 2019-05-04 | *      |
        | md5('1006') | 1006    | 2019-05-05 | *      |
        | md5('1007') | 1007    | 2019-05-05 | *      |
        | md5('1008') | 1008    | 2019-05-06 | *      |
        | md5('1009') | 1009    | 2019-05-06 | *      |