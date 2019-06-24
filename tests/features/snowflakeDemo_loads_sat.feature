@test_data
Feature: Loads Satellites
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 24.06.19 CF  1.0     First release.
# =============================================================================

  Scenario: Distinct history of data is loaded into a satellite table
    Given I have a HUB_CUSTOMER table
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have an empty satellite
    And I have data in the STG_CUSTOMER table
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |SOURCE|
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|TPCH  |
    When I run the satellite load sql
    Then only distinct records are loaded into the satellite
      |HASHDIFF                     |CUSTOMER_PK|CUSTOMER_NAME|CUSTOMER_PHONE  |LOADDATE  |SOURCE|
      |md5('ALICE**17-214-233-1214')|md5('1001')|Alice        |17-214-233-1214 |1993-01-01|TPCH  |
      |md5('BOB**17-214-233-1215')  |md5('1002')|Bob          |17-214-233-1215 |1993-01-01|TPCH  |
      |md5('CHAD**17-214-233-1216') |md5('1003')|Chad         |17-214-233-1216 |1993-01-01|TPCH  |
      |md5('DOM**17-214-233-1217')  |md5('1004')|Dom          |17-214-233-1217 |1993-01-01|TPCH  |

  Scenario: Unchanged records are not loaded into the satellite
    Given I have a HUB_CUSTOMER table
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have a satellite with pre-existing data
      |HASHDIFF                     |CUSTOMER_PK|CUSTOMER_NAME|CUSTOMER_PHONE  |LOADDATE  |SOURCE|
      |md5('ALICE**17-214-233-1214')|md5('1001')|Alice        |17-214-233-1214 |1993-01-01|TPCH  |
      |md5('BOB**17-214-233-1215')  |md5('1002')|Bob          |17-214-233-1215 |1993-01-01|TPCH  |
      |md5('CHAD**17-214-233-1216') |md5('1003')|Chad         |17-214-233-1216 |1993-01-01|TPCH  |
      |md5('DOM**17-214-233-1217')  |md5('1004')|Dom          |17-214-233-1217 |1993-01-01|TPCH  |
    And I have data in the STG_CUSTOMER table
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |SOURCE|
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-02|TPCH  |
    When I run the satellite load sql
    Then any unchanged records are not loaded into the satellite
      |HASHDIFF                     |CUSTOMER_PK|CUSTOMER_NAME|CUSTOMER_PHONE  |LOADDATE  |SOURCE|
      |md5('ALICE**17-214-233-1214')|md5('1001')|Alice        |17-214-233-1214 |1993-01-01|TPCH  |
      |md5('BOB**17-214-233-1215')  |md5('1002')|Bob          |17-214-233-1215 |1993-01-01|TPCH  |
      |md5('CHAD**17-214-233-1216') |md5('1003')|Chad         |17-214-233-1216 |1993-01-01|TPCH  |
      |md5('DOM**17-214-233-1217')  |md5('1004')|Dom          |17-214-233-1217 |1993-01-01|TPCH  |

  Scenario: Changed records are added to the satellite
    Given I have a HUB_CUSTOMER table
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have a satellite with pre-existing data
      |HASHDIFF                     |CUSTOMER_PK|CUSTOMER_NAME|CUSTOMER_PHONE  |LOADDATE  |SOURCE|
      |md5('ALICE**17-214-233-1214')|md5('1001')|Alice        |17-214-233-1214 |1993-01-01|TPCH  |
      |md5('BOB**17-214-233-1215')  |md5('1002')|Bob          |17-214-233-1215 |1993-01-01|TPCH  |
      |md5('CHAD**17-214-233-1216') |md5('1003')|Chad         |17-214-233-1216 |1993-01-01|TPCH  |
      |md5('DOM**17-214-233-1217')  |md5('1004')|Dom          |17-214-233-1217 |1993-01-01|TPCH  |
    And I have data in the STG_CUSTOMER table
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |SOURCE|
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1219')|1001       |Alice        |17-214-233-1219 |7                 |1993-01-02|TPCH  |
    When I run the satellite load sql
    Then any changed records are loaded to the satellite
      |HASHDIFF                     |CUSTOMER_PK|CUSTOMER_NAME|CUSTOMER_PHONE  |LOADDATE  |SOURCE|
      |md5('ALICE**17-214-233-1214')|md5('1001')|Alice        |17-214-233-1214 |1993-01-01|TPCH  |
      |md5('BOB**17-214-233-1215')  |md5('1002')|Bob          |17-214-233-1215 |1993-01-01|TPCH  |
      |md5('CHAD**17-214-233-1216') |md5('1003')|Chad         |17-214-233-1216 |1993-01-01|TPCH  |
      |md5('DOM**17-214-233-1217')  |md5('1004')|Dom          |17-214-233-1217 |1993-01-01|TPCH  |
      |md5('ALICE**17-214-233-1219')|md5('1001')|Alice        |17-214-233-1219 |1993-01-02|TPCH  |

  Scenario: If there are duplicate records in the history only the latest is loaded
    Given I have a HUB_CUSTOMER table
      | customer_pk | customerkey | loaddate   | source |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
      | md5('1003') | 1003        | 1993-01-01 | TPCH   |
      | md5('1004') | 1004        | 1993-01-01 | TPCH   |
    And I have an empty satellite
    And I have data in the STG_CUSTOMER table
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |SOURCE|
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1992-12-31|TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|TPCH  |
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|TPCH  |
    When I run the satellite load sql
    Then only the latest records are loaded into the satellite
      |HASHDIFF                     |CUSTOMER_PK|CUSTOMER_NAME|CUSTOMER_PHONE  |LOADDATE  |SOURCE|
      |md5('ALICE**17-214-233-1214')|md5('1001')|Alice        |17-214-233-1214 |1993-01-01|TPCH  |
      |md5('BOB**17-214-233-1215')  |md5('1002')|Bob          |17-214-233-1215 |1993-01-01|TPCH  |
      |md5('CHAD**17-214-233-1216') |md5('1003')|Chad         |17-214-233-1216 |1993-01-01|TPCH  |
      |md5('DOM**17-214-233-1217')  |md5('1004')|Dom          |17-214-233-1217 |1993-01-01|TPCH  |
