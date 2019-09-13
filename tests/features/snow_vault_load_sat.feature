@test_data
Feature: Load Satellites For Hubs
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 24.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# =============================================================================

  Scenario: Distinct history of data is loaded into a satellite table
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have an empty SAT_HUB_CUSTOMER satellite
    And I have data in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
    When I run the dbt satellite load sql
    Then only distinct records are loaded into the satellite
      | HASHDIFF                      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214') | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BOB**17-214-233-1215')   | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')  | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')   | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |


  Scenario: Unchanged records are not loaded into the satellite
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have a SAT_HUB_CUSTOMER satellite with pre-existing data
      | HASHDIFF                      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214') | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BOB**17-214-233-1215')   | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')  | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')   | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |
    And I have data in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-02 | 1993-01-01     | TPCH   |
    When I run the dbt day satellite load sql
    Then any unchanged records are not loaded into the satellite
      | HASHDIFF                      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214') | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BOB**17-214-233-1215')   | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')  | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')   | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |


  Scenario: Changed records are added to the satellite
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have a TEST_SAT_HUB_CUSTOMER satellite with pre-existing data
      | HASHDIFF                      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214') | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BOB**17-214-233-1215')   | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')  | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')   | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |
    And I have data in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1219') | 1001        | Alice         | 17-214-233-1219 | 7                  | 1993-01-02 | 1993-01-02     | TPCH   |
    When I run the dbt day satellite load sql
    Then any changed records are loaded to the satellite
      | HASHDIFF                      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214') | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('ALICE**17-214-233-1219') | md5('1001') | Alice         | 17-214-233-1219 | 1993-01-02 | 1993-01-02     | TPCH   |
      | md5('BOB**17-214-233-1215')   | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')  | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')   | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |


  Scenario: If there are duplicate records in the history only the latest is loaded
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have an empty SAT_HUB_CUSTOMER satellite
    And I have data in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                      | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1992-12-31 | 1992-12-31     | TPCH   |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214') | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')   | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')  | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')   | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
    When I run the dbt day satellite load sql
    Then only the latest records are loaded into the satellite
      | HASHDIFF                      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214') | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BOB**17-214-233-1215')   | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')  | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')   | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |


  Scenario: Changed records are added to the satellite when there is a duplicate hashdiff
    Given I have a HUB_CUSTOMER table
      | CUSTOMER_PK | CUSTOMERKEY | LOADDATE   | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
      | md5('1005') | 1005        | 1993-01-01 | TPCH   |
      | md5('1006') | 1006        | 1993-01-01 | TPCH   |
    And I have a TEST_SAT_HUB_CUSTOMER satellite with pre-existing data
      | HASHDIFF                       | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214')  | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BOB**17-214-233-1215')    | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')   | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')    | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('ANDREW**17-200-233-1216') | md5('1005') | Andrew        | 17-200-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('ANDREW**17-200-233-1216') | md5('1006') | Andrew        | 17-200-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
    And I have data in the STG_CUSTOMER table
      | CUSTOMER_PK | NATION_PK | CUSTOMER_NATION_PK | HASHDIFF                       | CUSTOMERKEY | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_NATIONKEY | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001') | md5('7')  | md5('1001**7')     | md5('ALICE**17-214-233-1214')  | 1001        | Alice         | 17-214-233-1214 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1002') | md5('8')  | md5('1002**8')     | md5('BOB**17-214-233-1215')    | 1002        | Bob           | 17-214-233-1215 | 8                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1003') | md5('4')  | md5('1003**4')     | md5('CHAD**17-214-233-1216')   | 1003        | Chad          | 17-214-233-1216 | 4                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1004') | md5('9')  | md5('1004**9')     | md5('DOM**17-214-233-1217')    | 1004        | Dom           | 17-214-233-1217 | 9                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1005') | md5('7')  | md5('1005**7')     | md5('ANDREW**17-200-233-1216') | 1005        | Andrew        | 17-200-233-1216 | 7                  | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('1006') | md5('9')  | md5('1006**9')     | md5('BRIAN**17-200-233-1216')  | 1006        | Brian         | 17-200-233-1216 | 9                  | 1993-01-02 | 1993-01-02     | TPCH   |
    When I run the dbt day satellite load sql
    Then any changed records are loaded to the satellite
      | HASHDIFF                       | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('ALICE**17-214-233-1214')  | md5('1001') | Alice         | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BOB**17-214-233-1215')    | md5('1002') | Bob           | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('CHAD**17-214-233-1216')   | md5('1003') | Chad          | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('DOM**17-214-233-1217')    | md5('1004') | Dom           | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('ANDREW**17-200-233-1216') | md5('1005') | Andrew        | 17-200-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('ANDREW**17-200-233-1216') | md5('1006') | Andrew        | 17-200-233-1216 | 1993-01-01 | 1993-01-01     | TPCH   |
      | md5('BRIAN**17-200-233-1216')  | md5('1006') | Brian         | 17-200-233-1216 | 1993-01-02 | 1993-01-02     | TPCH   |