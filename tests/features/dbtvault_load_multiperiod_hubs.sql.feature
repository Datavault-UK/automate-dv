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

  