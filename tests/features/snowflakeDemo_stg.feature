@test_data
Feature: Staging Table
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 20.06.19 CF  1.0     First release.
# =============================================================================


  Scenario: The data from v_history is staged into a view with hashes, loaddates, and sources for the customers
    Given there are records in v_history
    |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|
    |1001       |Alice        |17-214-233-1214 |7                 |
    |1001       |Alice        |17-214-233-1214 |7                 |
    |1002       |Bob          |17-214-233-1215 |8                 |
    |1003       |Chad         |17-214-233-1216 |4                 |
    |1004       |Dom          |17-214-233-1217 |9                 |
    When I run the sql query to create the staging view for the customers from the v_history
    Then there are records in v_stg_customer
    And it contains the original data and required hashes
      |CUSTOMER_PK|NATION_PK|CUSTOMER_NATION_PK|HASHDIFF                     |CUSTOMERKEY|CUSTOMER_NAME|CUSTOMER_PHONE  |CUSTOMER_NATIONKEY|LOADDATE  |EFFECTIVE_FROM|SOURCE|
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|1993-01-01    |TPCH  |
      |md5('1001')|md5('7') |md5('1001**7')    |md5('ALICE**17-214-233-1214')|1001       |Alice        |17-214-233-1214 |7                 |1993-01-01|1993-01-01    |TPCH  |
      |md5('1002')|md5('8') |md5('1002**8')    |md5('BOB**17-214-233-1215')  |1002       |Bob          |17-214-233-1215 |8                 |1993-01-01|1993-01-01    |TPCH  |
      |md5('1003')|md5('4') |md5('1003**4')    |md5('CHAD**17-214-233-1216') |1003       |Chad         |17-214-233-1216 |4                 |1993-01-01|1993-01-01    |TPCH  |
      |md5('1004')|md5('9') |md5('1004**9')    |md5('DOM**17-214-233-1217')  |1004       |Dom          |17-214-233-1217 |9                 |1993-01-01|1993-01-01    |TPCH  |
