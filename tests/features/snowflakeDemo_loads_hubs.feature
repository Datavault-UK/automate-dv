@test_data
Feature: Loads Hubs
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 18.06.19 CF  1.0     First release.
# =============================================================================
  @clean_data
  Scenario: Distinct history of data from the stage is loaded into an empty hub
    Given there is an empty HUB_CUSTOMER table
    And there are records in the STG_CUSTOMER table
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |SOURCE|
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|TPCH  |
    When I run the hub history load sql script
    Then only distinct records from STG_CUSTOMER are inserted into HUB_CUSTOMER
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: Unchanged records in stage are not loaded into the hub with pre-existing data
    Given there are records in the HUB_CUSTOMER table
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And there is data in the stage
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |SOURCE|
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-02|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-02|TPCH  |
    When I run the hub load sql script
    Then only different or unchanged records are loaded to the hub
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |

  Scenario: Only the first instance of a record is loaded into the hub table for the history
    Given there is an empty HUB_CUSTOMER table
    And there is data in the stage
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |SOURCE|
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-02|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-02|TPCH  |
    When I run the hub load sql script
    Then only the first instance of a distinct record is loaded into the hub
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |