@test_data
@clean_data
Feature: Loading data into a satellite with changing payloads
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 23.09.19 AH  1.0     First release.
# =============================================================================

  Scenario: Test several load cycles
    Given there is an empty TEST_STG_CUSTOMER table
    And there is an empty TEST_STG_BOOKING table
    And the TEST_SAT_CUST_CUSTOMER table is empty

    # ================ DAY 1 ===================
    When the TEST_STG_CUSTOMER table has data inserted into it for day 1
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOADDATE   |
      | 1001        | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 |
      | 1002        | Beth          | 1995-08-07   | 2019-05-04     | 2019-05-04 |
      | 1002        | Jack          | 1995-08-07   | 2019-05-04     | 2019-05-04 |
    And the TEST_STG_BOOKING table has data inserted into it for day 1
      | BOOKING_REF | CUSTOMER_ID | BOOKING_DATE | PRICE | DEPARTURE_DATE | DESTINATION | PHONE           | NATIONALITY | LOADDATE   |
      | 10034       | 1001        | 2019-05-03   | 100.0 | 2019-09-17     | GBR         | 17-214-233-1214 | BRITISH     | 2019-05-04 |
      | 10035       | 1002        | 2019-05-03   | 80.0  | 2019-09-16     | NLD         | 17-214-200-1214 | DUTCH       | 2019-05-04 |
    And the TEST_SAT_CUST_CUSTOMER is loaded for day 1

    # ================ DAY 2 ===================
    When the TEST_STG_CUSTOMER table has data inserted into it for day 2
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOADDATE   |
      | 1002        | Beth          | 1995-08-07   | 2019-05-05     | 2019-05-05 |
      | 1002        | Bethany       | 1995-08-07   | 2019-05-05     | 2019-05-05 |
      | 1003        | Michael       | 1990-02-03   | 2019-05-05     | 2019-05-05 |
      | 1004        | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 |
    And the TEST_STG_BOOKING table has data inserted into it for day 2
      | BOOKING_REF | CUSTOMER_ID | BOOKING_DATE | PRICE | DEPARTURE_DATE | DESTINATION | PHONE           | NATIONALITY | LOADDATE   |
      | 10036       | 1003        | 2019-05-04   | 70.0  | 2019-09-13     | AUS         | 17-214-555-1214 | AUSTRALIAN  | 2019-05-05 |
      | 10037       | 1004        | 2019-05-04   | 810.0 | 2019-09-18     | DEU         | 17-214-123-1214 | GERMAN      | 2019-05-05 |
    And the TEST_SAT_CUST_CUSTOMER is loaded for day 2

    # =============== CHECKS ===================
    Then we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain
      | CUSTOMER_PK | HASHDIFF                             | NAME    | DOB        | EFFECTIVE_FROM | LOADDATE   | SOURCE |
      | md5('1001') | md5('1001\|\|ALBERT\|\|1990-02-03')  | Albert  | 1990-02-03 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|1995-08-07')    | Beth    | 1995-08-07 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|JACK\|\|1995-08-07')    | Jack    | 1995-08-07 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|1995-08-07')    | Beth    | 1995-08-07 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1002') | md5('1002\|\|BETHANY\|\|1995-08-07') | Bethany | 1995-08-07 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1003') | md5('1003\|\|MICHAEL\|\|1990-02-03') | Michael | 1990-02-03 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1004') | md5('1004\|\|DAVID\|\|1992-01-30')   | David   | 1992-01-30 | 2019-05-05     | 2019-05-05 | *      |