@test_data
@clean_data
Feature: Loads Hubs
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 18.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# =============================================================================

  Scenario: [SINGLE-SOURCE] Distinct history of data from the stage is loaded into an empty hub
    Given there is an empty TEST_HUB_CUSTOMER table
    And there are records in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
    When I run the dbt hub load sql script
    Then only distinct records from STG_CUSTOMER are inserted into HUB_CUSTOMER
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: [SINGLE-SOURCE] Unchanged records in stage are not loaded into the hub with pre-existing data
    Given there are records in the HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And there are records in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-02 | 1993-01-02     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-02 | 1993-01-02     | TPCH   |
    When I run the dbt hub load sql script
    Then only different or unchanged records are loaded into HUB_CUSTOMER
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-02 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: [SINGLE-SOURCE] Only one instance of a record is loaded into the hub table for the history with multiple sources
    Given there is an empty TEST_HUB_CUSTOMER table
    And there are records in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPC2   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPC3   |
    When I run the dbt hub load sql script
    Then only the first instance of a distinct record is loaded into HUB_CUSTOMER
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPC1   |
      | md5('1002') | 1002        | 1993-01-01 | TPC1   |
      | md5('1003') | 1003        | 1993-01-01 | TPC1   |
      | md5('1004') | 1004        | 1993-01-01 | TPC1   |

  Scenario: [UNION] Distinct history of data from a union of stage tables is loaded into an empty HUB_PART
    Given there is an empty TEST_HUB_PART table
    And there are records in the STG_PART table
      | PART_PK     | PARTKEY | NAME   | TYPE     | SIZE | RETAILPRICE | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | 1001    | Pedal  | internal | M    | 60.00       | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1002') | 1002    | Door   | external | XL   | 150.00      | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1003') | 1003    | Seat   | internal | R    | 27.68       | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1004') | 1004    | Aerial | external | S    | 10.40       | 1993-01-01 | 1993-01-02     | TPC1   |
      | md5('1005') | 1005    | Cover  | other    | L    | 1.50        | 1993-01-01 | 1993-01-02     | TPC1   |
    And there are records in the STG_PARTSUPP table
      | PART_PK     | SUPP_PK   | PARTKEY | AVAILQTY | SUPPLYCOST | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('9')  | 1001    | 6        | 68.00      | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1002') | md5('11') | 1002    | 2        | 120.00     | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1003') | md5('11') | 1003    | 1        | 29.87      | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1004') | md5('6')  | 1004    | 3        | 101.40     | 1993-01-01 | 1993-01-02     | TPC1   |
      | md5('1005') | md5('7')  | 1005    | 8        | 10.50      | 1993-01-01 | 1993-01-02     | TPC1   |
    And there are records in the STG_LINEITEM table
      | ORDER_PK     | PART_PK     | SUPP_PK   | PARTKEY | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('10001') | md5('1001') | md5('9')  | 1001    | 1234       | 6        | 168.00         | 18.00    | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('10002') | md5('1002') | md5('11') | 1002    | 1235       | 2        | 10.00          | 1.00     | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('10003') | md5('1003') | md5('11') | 1003    | 1236       | 1        | 290.87         | 2.00     | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('10004') | md5('1004') | md5('6')  | 1004    | 1237       | 3        | 10.40          | 5.50     | 1993-01-01 | 1993-01-02     | TPC1   |
      | md5('10005') | md5('1005') | md5('7')  | 1005    | 1238       | 8        | 106.50         | 21.10    | 1993-01-01 | 1993-01-02     | TPC1   |
    When I run the dbt hub load sql script with unions
    Then only distinct records from the union are inserted into HUB_PART
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | TPC1   |
      | md5('1002') | 1002    | 1993-01-01 | TPC1   |
      | md5('1003') | 1003    | 1993-01-01 | TPC1   |
      | md5('1004') | 1004    | 1993-01-01 | TPC1   |
      | md5('1005') | 1005    | 1993-01-01 | TPC1   |

  Scenario: [UNION] Unchanged records in stage are not loaded into the union hub with pre-existing data
    Given there are records in the HUB_PART table
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | TPC1   |
      | md5('1002') | 1002    | 1993-01-01 | TPC1   |
    And there are records in the STG_PART table
      | PART_PK     | PARTKEY | NAME      | TYPE     | SIZE | RETAILPRICE | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | 1001    | Pedal     | internal | M    | 60.00       | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1002') | 1002    | Door      | external | XL   | 150.00      | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1003') | 1003    | Seat      | internal | R    | 27.68       | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1004') | 1004    | Aerial    | external | S    | 10.40       | 1993-01-01 | 1993-01-02     | TPC1   |
      | md5('1005') | 1005    | Cover     | other    | L    | 1.50        | 1993-01-01 | 1993-01-02     | TPC1   |
      | md5('1006') | 1006    | Gearstick | internal | L    | 1.50        | 1993-01-01 | 1993-01-02     | TPC1   |
    And there are records in the STG_PARTSUPP table
      | PART_PK     | SUPP_PK   | PARTKEY | AVAILQTY | SUPPLYCOST | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('9')  | 1001    | 6        | 68.00      | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1002') | md5('11') | 1002    | 2        | 120.00     | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1003') | md5('11') | 1003    | 1        | 29.87      | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1004') | md5('6')  | 1004    | 3        | 101.40     | 1993-01-01 | 1993-01-02     | TPC1   |
      | md5('1005') | md5('7')  | 1005    | 8        | 10.50      | 1993-01-01 | 1993-01-02     | TPC1   |
    And there are records in the STG_LINEITEM table
      | ORDER_PK     | PART_PK     | SUPP_PK   | PARTKEY | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('10001') | md5('1001') | md5('9')  | 1001    | 1234       | 6        | 168.00         | 18.00    | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('10002') | md5('1002') | md5('11') | 1002    | 1235       | 2        | 10.00          | 1.00     | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('10003') | md5('1003') | md5('11') | 1003    | 1236       | 1        | 290.87         | 2.00     | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('10004') | md5('1004') | md5('6')  | 1004    | 1237       | 3        | 10.40          | 5.50     | 1993-01-01 | 1993-01-02     | TPC1   |
      | md5('10005') | md5('1005') | md5('7')  | 1005    | 1238       | 8        | 106.50         | 21.10    | 1993-01-01 | 1993-01-02     | TPC1   |
    When I run the dbt hub load sql script with unions
    Then only different or unchanged records are loaded into HUB_PART
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | TPC1   |
      | md5('1002') | 1002    | 1993-01-01 | TPC1   |
      | md5('1003') | 1003    | 1993-01-01 | TPC1   |
      | md5('1004') | 1004    | 1993-01-01 | TPC1   |
      | md5('1005') | 1005    | 1993-01-01 | TPC1   |
      | md5('1006') | 1006    | 1993-01-01 | TPC1   |

  Scenario: [UNION] Only one instance of a record is loaded into the union hub table for the history with multiple sources
    Given there are records in the HUB_PART table
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | TPC1   |
      | md5('1002') | 1002    | 1993-01-01 | TPC1   |
    And there are records in the STG_PART table
      | PART_PK     | PARTKEY | NAME   | TYPE     | SIZE | RETAILPRICE | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | 1001    | Pedal  | internal | M    | 60.00       | 1993-01-01 | 1993-01-01     | PART   |
      | md5('1002') | 1002    | Door   | external | XL   | 150.00      | 1993-01-01 | 1993-01-01     | PART   |
      | md5('1003') | 1003    | Seat   | internal | R    | 27.68       | 1993-01-01 | 1993-01-01     | PART   |
      | md5('1004') | 1004    | Aerial | external | S    | 10.40       | 1993-01-01 | 1993-01-02     | PART   |
      | md5('1005') | 1005    | Cover  | other    | L    | 1.50        | 1993-01-01 | 1993-01-02     | PART   |
    And there are records in the STG_PARTSUPP table
      | PART_PK     | SUPP_PK   | PARTKEY | AVAILQTY | SUPPLYCOST | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('9')  | 1001    | 6        | 68.00      | 1993-01-01 | 1993-01-01     | PSUP   |
      | md5('1002') | md5('11') | 1002    | 2        | 120.00     | 1993-01-01 | 1993-01-01     | PSUP   |
      | md5('1003') | md5('11') | 1003    | 1        | 29.87      | 1993-01-01 | 1993-01-01     | PSUP   |
      | md5('1004') | md5('6')  | 1004    | 3        | 101.40     | 1993-01-01 | 1993-01-02     | PSUP   |
      | md5('1005') | md5('7')  | 1005    | 8        | 10.50      | 1993-01-01 | 1993-01-02     | PSUP   |
    And there are records in the STG_LINEITEM table
      | ORDER_PK     | PART_PK     | SUPP_PK   | PARTKEY | LINENUMBER | QUANTITY | EXTENDED_PRICE | DISCOUNT | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('10001') | md5('1001') | md5('9')  | 1001    | 1234       | 6        | 168.00         | 18.00    | 1993-01-01 | 1993-01-01     | LITE   |
      | md5('10002') | md5('1002') | md5('11') | 1002    | 1235       | 2        | 10.00          | 1.00     | 1993-01-01 | 1993-01-01     | LITE   |
      | md5('10003') | md5('1003') | md5('11') | 1003    | 1236       | 1        | 290.87         | 2.00     | 1993-01-01 | 1993-01-01     | LITE   |
      | md5('10004') | md5('1004') | md5('6')  | 1004    | 1237       | 3        | 10.40          | 5.50     | 1993-01-01 | 1993-01-02     | LITE   |
      | md5('10005') | md5('1005') | md5('7')  | 1005    | 1238       | 8        | 106.50         | 21.10    | 1993-01-01 | 1993-01-02     | LITE   |
      | md5('10006') | md5('1006') | md5('45') | 1006    | 1238       | 8        | 106.50         | 21.10    | 1993-01-01 | 1993-01-02     | LITE   |
    When I run the dbt hub load sql script with unions
    Then only the first instance of a distinct record is loaded into HUB_PART
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1993-01-01 | PART   |
      | md5('1002') | 1002    | 1993-01-01 | PART   |
      | md5('1003') | 1003    | 1993-01-01 | PART   |
      | md5('1004') | 1004    | 1993-01-01 | PART   |
      | md5('1005') | 1005    | 1993-01-01 | PART   |
      | md5('1006') | 1006    | 1993-01-01 | LITE   |