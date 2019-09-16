@test_data
@clean_data
Feature: Load cycles
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
    And there is an empty TEST_STG_BOOKING table
    And there is an empty TEST_HUB_CUSTOMER table
    And there is an empty TEST_HUB_BOOKING table
    And there is an empty TEST_LINK_CUSTOMER_BOOKING table
    And there is an empty TEST_SAT_CUST_CUSTOMER_DETAILS table
    And there is an empty TEST_SAT_BOOK_CUSTOMER_DETAILS table
    And there is an empty TEST_SAT_BOOK_BOOKING_DETAILS table
    When the TEST_STG_CUSTOMER table receives a feed for day 1
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE  | EFFECTIVE_FROM |
      | 1001        | Albert        | 01/01/2000   | 2019-05-04 | 2019-05-03     |
      | 1002        | Beth          | 03/04/2001   | 2019-05-04 | 2019-05-03     |
    And the TEST_STG_BOOKING table receives a feed for day 1
      | BOOKING_REF | CUSTOMER_ID | PRICE | DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY |
    And the vault is loaded for day 1
    When the TEST_STG_CUSTOMER table receives a feed for day 2
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE | EFFECTIVE_FROM |
    And the TEST_STG_BOOKING table receives a feed for day 2
      | BOOKING_REF | CUSTOMER_ID | PRICE | DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY |
    And the vault is loaded for day 2
    When the TEST_STG_CUSTOMER table receives a feed for day 3
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE | EFFECTIVE_FROM |
    And the TEST_STG_BOOKING table receives a feed for day 3
      | BOOKING_REF | CUSTOMER_ID | PRICE | DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY |
    And the vault is loaded for day 3
    When the TEST_STG_CUSTOMER table receives a feed for day 4
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | LOAD_DATE | EFFECTIVE_FROM |
    And the TEST_STG_BOOKING table receives a feed for day 4
      | BOOKING_REF | CUSTOMER_ID | PRICE | DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY |
    And the vault is loaded for day 4
    Then we expect the TEST_HUB_CUSTOMER table to contain
      | CUSTOMER_PK | CUSTOMER_ID | SOURCE | LOAD_DATE  |
      | md5('1001') | 1001        | *      | 2019-05-04 |
      | md5('1002') | 1002        | *      | 2019-05-04 |
    And we expect the TEST_HUB_BOOKING table to contain
      | BOOKING_PK  | BOOKING_REF | SOURCE | LOAD_DATE  |
      | md5('1001') | 1001        | *      | 2019-05-04 |
      | md5('1002') | 1002        | *      | 2019-05-04 |
    And we expect the TEST_LINK_CUSTOMER_BOOKING table to contain
      | CUSTOMER_BOOKING_PK | CUSTOMER_PK | BOOKING_PK | SOURCE | LOAD_DATE  |
      | md5('1001')         | 1001        | 1001       | *      | 2019-05-04 |
      | md5('1002')         | 1002        | 1002       | *      | 2019-05-04 |
    And we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain
      | customer_pk | load_date  | source | hashdiff                        | effective_from | name   | dob        |
      | md5('1001') | 04/05/2019 | *      | md5('2000-01-01**1001**ALBERT') | 2019-05-03     | Albert | 2000-01-01 |
      | md5('1002') | 04/05/2019 | *      | md5('2001-04-03**1002**BETH')   | 2019-05-03     | Beth   | 2001-04-03 |
    And we expect the TEST_SAT_BOOK_CUSTOMER_DETAILS table to contain
      | BOOKING_PK | LOAD_DATE | EFFECTIVE_FROM | SOURCE | HASHDIFF | PRICE | DEPARTURE_DATE | DESTINATION |
    And we expect the TEST_SAT_BOOK_BOOKING_DETAILS table to contain
      | CUSTOMER_PK | LOAD_DATE | SOURCE | HASHDIFF | EFFECTIVE_FROM | PHONE | NATIONALITY |
