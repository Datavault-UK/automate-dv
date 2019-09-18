@test_data
@clean_data
Feature: Loading through multiple tables and cycles from source to vault
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 16.09.19 AH  1.0     First release.
# =============================================================================

  Scenario: Test several load cycles
    Given there is an empty TEST_STG_CUSTOMER table
    When the TEST_STG_CUSTOMER table has data inserted into it for day 1
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  |
      | 1001        | Albert        | 1990-02-03   | 2019-05-03     | 2019-05-04 |
      | 1002        | Beth          | 1995-08-07   | 2019-05-03     | 2019-05-04 |
    And the TEST_STG_BOOKING table has data inserted into it for day 1
      | BOOKING_REF | CUSTOMER_ID | PRICE  | DEPARTURE_DATE | DESTINATION | PHONE           | NATIONALITY |
      | 10034       | 1001        | 100.00 | 2019-09-17     | LON         | 17-214-233-1214 | BRITISH     |
      | 10035       | 1002        | 80.00  | 2019-09-16     | AMS         | 17-214-200-1214 | DUTCH       |
    And the vault is loaded for day 1
    When the TEST_STG_CUSTOMER table has data inserted into it for day 2
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOADDATE | EFFECTIVE_FROM |
    And the TEST_STG_BOOKING table has data inserted into it for day 2
      | BOOKING_REF | CUSTOMER_ID | PRICE | DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY |
    And the vault is loaded for day 2
    When the TEST_STG_CUSTOMER table has data inserted into it for day 3
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE | EFFECTIVE_FROM |
    And the TEST_STG_BOOKING table has data inserted into it for day 3
      | BOOKING_REF | CUSTOMER_ID | PRICE | DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY |
    And the vault is loaded for day 3
    When the TEST_STG_CUSTOMER table has data inserted into it for day 4
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE | EFFECTIVE_FROM |
    And the TEST_STG_BOOKING table has data inserted into it for day 4
      | BOOKING_REF | CUSTOMER_ID | PRICE | DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY |
    And the vault is loaded for day 4
    Then we expect the TEST_HUB_CUSTOMER table to contain
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2019-05-04 | *      |
      | md5('1002') | 1002        | 2019-05-04 | *      |
    And we expect the TEST_HUB_BOOKING table to contain
      | BOOKING_PK  | BOOKING_REF | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2019-05-04 | *      |
      | md5('1002') | 1002        | 2019-05-04 | *      |
    And we expect the TEST_LINK_CUSTOMER_BOOKING table to contain
      | CUSTOMER_BOOKING_PK | CUSTOMER_PK | BOOKING_PK | LOAD_DATE  | SOURCE |
      | md5('1001')         | 1001        | 1001       | 2019-05-04 | *      |
      | md5('1002')         | 1002        | 1002       | 2019-05-04 | *      |
    And we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain
      | CUSTOMER_PK | HASHDIFF                        | NAME   | DOB        | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('2000-01-01**1001**ALBERT') | Albert | 2000-01-01 | 2019-05-03     | 04/05/2019 | *      |
      | md5('1002') | md5('2001-04-03**1002**BETH')   | Beth   | 2001-04-03 | 2019-05-03     | 04/05/2019 | *      |
    And we expect the TEST_SAT_BOOK_CUSTOMER_DETAILS table to contain
      | BOOKING_PK | HASHDIFF | PRICE | DEPARTURE_DATE | DESTINATION | EFFECTIVE_FROM | LOAD_DATE | SOURCE
    And we expect the TEST_SAT_BOOK_BOOKING_DETAILS table to contain
      | CUSTOMER_PK | HASHDIFF | PHONE | NATIONALITY | EFFECTIVE_FROM | LOAD_DATE | SOURCE |
