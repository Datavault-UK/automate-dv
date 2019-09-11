@test_data
Feature: Loads Links
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 21.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# =============================================================================

  Scenario: Distinct history of data linking two hubs is loaded into a link table
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have a HUB_NATION table
      | NATION_PK | CUSTOMER_NATIONKEY | LOADDATE   | SOURCE |
      | md5('7')  | 7                  | 1993-01-01 | TPCH   |
      | md5('8')  | 8                  | 1993-01-01 | TPCH   |
      | md5('4')  | 4                  | 1993-01-01 | TPCH   |
      | md5('9')  | 9                  | 1993-01-01 | TPCH   |
    And I have an empty LINK_CUSTOMER_NATION table
    And I have data in the STG_CUSTOMER_NATION table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
    When I run the dbt load to the link
    Then only distinct records from the STG_CUSTOMER_NATION are loaded into the link
      | CUSTOMER_NATION_PK | CUSTOMER_PK | NATION_PK | LOADDATE   | SOURCE |
      | md5('1001**7')     | md5('1001') | md5('7')  | 1993-01-01 | TPCH   |
      | md5('1002**8')     | md5('1002') | md5('8')  | 1993-01-01 | TPCH   |
      | md5('1003**4')     | md5('1003') | md5('4')  | 1993-01-01 | TPCH   |
      | md5('1004**9')     | md5('1004') | md5('9')  | 1993-01-01 | TPCH   |

  Scenario: Unchanged records in stage are not loaded into the link with pre-existing data
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have a HUB_NATION table
      | NATION_PK | CUSTOMER_NATIONKEY | LOADDATE   | SOURCe |
      | md5('7')  | 7                  | 1993-01-01 | TPCH   |
      | md5('8')  | 8                  | 1993-01-01 | TPCH   |
      | md5('4')  | 4                  | 1993-01-01 | TPCH   |
      | md5('9')  | 9                  | 1993-01-01 | TPCH   |
    And I have data in the STG_CUSTOMER_NATION table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
    And there are records in the LINK_CUSTOMER_NATION table
      | CUSTOMER_NATION_PK | CUSTOMER_PK | NATION_PK | LOADDATE   | SOURCE |
      | md5('1001**7')     | md5('1001') | md5('7')  | 1993-01-01 | TPCH   |
      | md5('1002**8')     | md5('1002') | md5('8')  | 1993-01-01 | TPCH   |
    When I run the dbt day load to the link
    Then only different or unchanged records are loaded to the link
      | CUSTOMER_NATION_PK | CUSTOMER_PK | NATION_PK | LOADDATE   | SOURCE |
      | md5('1001**7')     | md5('1001') | md5('7')  | 1993-01-01 | TPCH   |
      | md5('1002**8')     | md5('1002') | md5('8')  | 1993-01-01 | TPCH   |
      | md5('1003**4')     | md5('1003') | md5('4')  | 1993-01-01 | TPCH   |
      | md5('1004**9')     | md5('1004') | md5('9')  | 1993-01-01 | TPCH   |


  Scenario: Only the first instance of a record is loaded into the link table for the history
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have a HUB_NATION table
      | NATION_PK | CUSTOMER_NATIONKEY | LOADDATE   | SOURCE |
      | md5('7')  | 7                  | 1993-01-01 | TPCH   |
      | md5('8')  | 8                  | 1993-01-01 | TPCH   |
      | md5('4')  | 4                  | 1993-01-01 | TPCH   |
      | md5('9')  | 9                  | 1993-01-01 | TPCH   |
    And I have an empty LINK_CUSTOMER_NATION table
    And I have unchanged records but with different sources in the STG_CUSTOMER_NATION table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPC2   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPC1   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPC1   |
    When I run the dbt day load to the link
    Then only the first seen distinct records are loaded into the link
      | CUSTOMER_NATION_PK | CUSTOMER_PK | NATION_PK | LOADDATE   | SOURCE |
      | md5('1001**7')     | md5('1001') | md5('7')  | 1993-01-01 | TPC1   |
      | md5('1002**8')     | md5('1002') | md5('8')  | 1993-01-01 | TPC1   |
      | md5('1003**4')     | md5('1003') | md5('4')  | 1993-01-01 | TPC1   |
      | md5('1004**9')     | md5('1004') | md5('9')  | 1993-01-01 | TPC1   |

  Scenario: Distinct history of data linking two hubs is loaded into a link table from a union
    Given I have a HUB_LINEITEM table
      | LINEITEM_PK | LINENUMBER | LOADDATE   | SOURCE |
      | md5('7')    | 7          | 1992-01-08 | TPCH   |
      | md5('8')    | 8          | 1992-01-08 | TPCH   |
      | md5('4')    | 4          | 1992-01-08 | TPCH   |
      | md5('9')    | 9          | 1992-01-08 | TPCH   |
    And I have a HUB_PARTS table
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1992-01-08 | TPCH   |
      | md5('1002') | 1002    | 1992-01-08 | TPCH   |
      | md5('1003') | 1003    | 1992-01-08 | TPCH   |
      | md5('1004') | 1004    | 1992-01-08 | TPCH   |
    And I have a HUB_SUPPLIER table
      | SUPPLIER_PK | SUPPLIERKEY | LOADDATE   | SOURCE |
      | md5('7')    | 7           | 1992-01-08 | TPCH   |
      | md5('8')    | 8           | 1992-01-08 | TPCH   |
      | md5('4')    | 4           | 1992-01-08 | TPCH   |
      | md5('9')    | 9           | 1992-01-08 | TPCH   |
    And I have a STG_LINEITEM table
      | INVENTORY_ALLOCATION_PK | LINEITEM_PK | LINENUMBER | SUPPLIER_PK | PART_PK     | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('7')    | 7          | md5('7')    | md5('1001') | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('8')    | 8          | md5('8')    | md5('1002') | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('4')    | 4          | md5('4')    | md5('1003') | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('9')    | 9          | md5('9')    | md5('1004') | 1992-01-08 | TPCH   |
    And I have a STG_PARTS table
      | INVENTORY_ALLOCATION_PK | PART_PK     | PARTKEY | LINEITEM_PK | SUPPLIER_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('1001') | 1001    | md5('7')    | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('1002') | 1002    | md5('8')    | md5('8')    | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('1003') | 1003    | md5('4')    | md5('4')    | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('1004') | 1004    | md5('9')    | md5('9')    | 1992-01-08 | TPCH   |
    And I have a STG_SUPPLIER table
      | INVENTORY_ALLOCATION_PK | SUPPLIER_PK | SUPPLIERKEY | PART_PK     | LINEITEM_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('7')    | 7           | md5('1001') | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('8')    | 8           | md5('1002') | md5('8')    | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('4')    | 4           | md5('1003') | md5('4')    | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('9')    | 9           | md5('1004') | md5('9')    | 1992-01-08 | TPCH   |
    And I have an empty LINK_INVENTORY_ALLOCATION table
    When I run the dbt union load to the link
    Then only distinct records from the stage union are loaded into the link
      | INVENTORY_ALLOCATION_PK | PART_PK     | SUPPLIER_PK | LINEITEM_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('1001') | md5('7')    | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('1002') | md5('8')    | md5('8')    | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('1003') | md5('4')    | md5('4')    | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('1004') | md5('9')    | md5('9')    | 1992-01-08 | TPCH   |


  Scenario: Unchanged records in stage are not loaded into the link with pre-existing data from a union
    Given I have a HUB_LINEITEM table
      | LINEITEM_PK | LINENUMBER | LOADDATE   | SOURCE |
      | md5('7')    | 7          | 1992-01-08 | TPCH   |
      | md5('8')    | 8          | 1992-01-08 | TPCH   |
      | md5('4')    | 4          | 1992-01-08 | TPCH   |
      | md5('9')    | 9          | 1992-01-08 | TPCH   |
    And I have a HUB_PARTS table
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1992-01-08 | TPCH   |
      | md5('1002') | 1002    | 1992-01-08 | TPCH   |
      | md5('1003') | 1003    | 1992-01-08 | TPCH   |
      | md5('1004') | 1004    | 1992-01-08 | TPCH   |
    And I have a HUB_SUPPLIER table
      | SUPPLIER_PK | SUPPLIERKEY | LOADDATE   | SOURCE |
      | md5('7')    | 7           | 1992-01-08 | TPCH   |
      | md5('8')    | 8           | 1992-01-08 | TPCH   |
      | md5('4')    | 4           | 1992-01-08 | TPCH   |
      | md5('9')    | 9           | 1992-01-08 | TPCH   |
    And I have a STG_LINEITEM table
      | INVENTORY_ALLOCATION_PK | LINEITEM_PK | LINENUMBER | SUPPLIER_PK | PART_PK     | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('7')    | 7          | md5('7')    | md5('1001') | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('8')    | 8          | md5('8')    | md5('1002') | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('4')    | 4          | md5('4')    | md5('1003') | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('9')    | 9          | md5('9')    | md5('1004') | 1992-01-08 | TPCH   |
    And I have a STG_PARTS table
      | INVENTORY_ALLOCATION_PK | PART_PK     | PARTKEY | LINEITEM_PK | SUPPLIER_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('1001') | 1001    | md5('7')    | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('1002') | 1002    | md5('8')    | md5('8')    | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('1003') | 1003    | md5('4')    | md5('4')    | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('1004') | 1004    | md5('9')    | md5('9')    | 1992-01-08 | TPCH   |
    And I have a STG_SUPPLIER table
      | INVENTORY_ALLOCATION_PK | SUPPLIER_PK | SUPPLIERKEY | PART_PK     | LINEITEM_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('7')    | 7           | md5('1001') | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('8')    | 8           | md5('1002') | md5('8')    | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('4')    | 4           | md5('1003') | md5('4')    | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('9')    | 9           | md5('1004') | md5('9')    | 1992-01-08 | TPCH   |
    And there are records in the LINK_INVENTORY_ALLOCATION table
      | INVENTORY_ALLOCATION_PK | PART_PK     | SUPPLIER_PK | LINEITEM_PK | LOADDATE   | SOURCE |
      | md5('1001**7**1001')    | md5('1001') | md5('7')    | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1004**8**1002')    | md5('1002') | md5('8')    | md5('8')    | 1992-01-08 | TPCH   |
    When I run the dbt union load to the link
    Then only distinct records from the stage union are loaded into the link
      | INVENTORY_ALLOCATION_PK | PART_PK     | SUPPLIER_PK | LINEITEM_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('1001') | md5('7')    | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('1002') | md5('8')    | md5('8')    | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('1003') | md5('4')    | md5('4')    | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('1004') | md5('9')    | md5('9')    | 1992-01-08 | TPCH   |

  Scenario: Only the first instance of a record is loaded into the link table for the history from a union
    Given I have a HUB_LINEITEM table
      | LINEITEM_PK | LINENUMBER | LOADDATE   | SOURCE |
      | md5('7')    | 7          | 1992-01-08 | LINE   |
      | md5('8')    | 8          | 1992-01-08 | LINE   |
      | md5('4')    | 4          | 1992-01-08 | LINE   |
      | md5('9')    | 9          | 1992-01-08 | LINE   |
    And I have a HUB_PARTS table
      | PART_PK     | PARTKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001    | 1992-01-08 | PART   |
      | md5('1002') | 1002    | 1992-01-08 | PART   |
      | md5('1003') | 1003    | 1992-01-08 | PART   |
      | md5('1004') | 1004    | 1992-01-08 | PART   |
    And I have a HUB_SUPPLIER table
      | SUPPLIER_PK | SUPPLIERKEY | LOADDATE   | SOURCE |
      | md5('7')    | 7           | 1992-01-08 | SUPP   |
      | md5('8')    | 8           | 1992-01-08 | SUPP   |
      | md5('4')    | 4           | 1992-01-08 | SUPP   |
      | md5('9')    | 9           | 1992-01-08 | SUPP   |
    And I have a STG_LINEITEM table
      | INVENTORY_ALLOCATION_PK | LINEITEM_PK | LINENUMBER | SUPPLIER_PK | PART_PK     | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('7')    | 7          | md5('7')    | md5('1001') | 1992-01-08 | LINE   |
      | md5('1002**8**8')       | md5('8')    | 8          | md5('8')    | md5('1002') | 1992-01-08 | LINE   |
      | md5('1003**4**4')       | md5('4')    | 4          | md5('4')    | md5('1003') | 1992-01-08 | LINE   |
      | md5('1004**9**9')       | md5('9')    | 9          | md5('9')    | md5('1004') | 1992-01-08 | LINE   |
    And I have a STG_PARTS table
      | INVENTORY_ALLOCATION_PK | PART_PK     | PARTKEY | LINEITEM_PK | SUPPLIER_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('1001') | 1001    | md5('7')    | md5('7')    | 1992-01-08 | PART   |
      | md5('1002**8**8')       | md5('1002') | 1002    | md5('8')    | md5('8')    | 1992-01-08 | PART   |
      | md5('1003**4**4')       | md5('1003') | 1003    | md5('4')    | md5('4')    | 1992-01-08 | PART   |
      | md5('1004**9**9')       | md5('1004') | 1004    | md5('9')    | md5('9')    | 1992-01-08 | PART   |
    And I have a STG_SUPPLIER table
      | INVENTORY_ALLOCATION_PK | SUPPLIER_PK | SUPPLIERKEY | PART_PK     | LINEITEM_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('7')    | 7           | md5('1001') | md5('7')    | 1992-01-08 | SUPP   |
      | md5('1002**8**8')       | md5('8')    | 8           | md5('1002') | md5('8')    | 1992-01-08 | SUPP   |
      | md5('1003**4**4')       | md5('4')    | 4           | md5('1003') | md5('4')    | 1992-01-08 | SUPP   |
      | md5('1004**9**9')       | md5('9')    | 9           | md5('1004') | md5('9')    | 1992-01-08 | SUPP   |
      | md5('1009**3**3')       | md5('3')    | 3           | md5('1009') | md5('3')    | 1992-01-08 | SUPP   |
    And I have an empty LINK_INVENTORY_ALLOCATION table
    When I run the dbt union load to the link
    Then only the first seen distinct records are loaded into the link from a union
      | INVENTORY_ALLOCATION_PK | PART_PK     | SUPPLIER_PK | LINEITEM_PK | LOADDATE   | SOURCE |
      | md5('1001**7**7')       | md5('1001') | md5('7')    | md5('7')    | 1992-01-08 | TPCH   |
      | md5('1002**8**8')       | md5('1002') | md5('8')    | md5('8')    | 1992-01-08 | TPCH   |
      | md5('1003**4**4')       | md5('1003') | md5('4')    | md5('4')    | 1992-01-08 | TPCH   |
      | md5('1004**9**9')       | md5('1004') | md5('9')    | md5('9')    | 1992-01-08 | TPCH   |
      | md5('1009**3**3')       | md5('1009') | md5('3')    | md5('3')    | 1992-01-08 | TPCH   |

