@test_data
Feature: Load Satellites
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 24.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# 24.09.19 NS  1.2     Reviewed and refactored.
# =============================================================================

# -----------------------------------------------------------------------------
# Test load into an empty satellite, first load.
# -----------------------------------------------------------------------------
  Scenario: Load data into an empty satellite.
    Given the TEST_STG_CUSTOMER table has data inserted into it
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    When I run a fresh dbt sat load
    Then the SAT_CUSTOMER_DETAILS table should contain
      | HASHDIFF                                              | CUSTOMER_PK | NAME  | PHONE           | DOB        | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|1997-04-24') | md5('1001') | Alice | 17-214-233-1214 | 1997-04-24 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002\|\|BOB\|\|17-214-233-1215\|\|2006-04-17')   | md5('1002') | Bob   | 17-214-233-1215 | 2006-04-17 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|2013-02-04')  | md5('1003') | Chad  | 17-214-233-1216 | 2013-02-04 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1004\|\|DOM\|\|17-214-233-1217\|\|2018-04-13')   | md5('1004') | Dom   | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |


  Scenario: Load duplicated data into an empty satellite.
    Given the TEST_STG_CUSTOMER table has data inserted into it
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    When I run a fresh dbt sat load
    Then records are inserted into the satellite
      | HASHDIFF                                              | CUSTOMER_PK | NAME  | PHONE           | DOB        | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|1997-04-24') | md5('1001') | Alice | 17-214-233-1214 | 1997-04-24 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1002\|\|BOB\|\|17-214-233-1215\|\|2006-04-17')   | md5('1002') | Bob   | 17-214-233-1215 | 2006-04-17 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|2013-02-04')  | md5('1003') | Chad  | 17-214-233-1216 | 2013-02-04 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1004\|\|DOM\|\|17-214-233-1217\|\|2018-04-13')   | md5('1004') | Dom   | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |


# -----------------------------------------------------------------------------
# Test load into a populated satellite.
# -----------------------------------------------------------------------------
  Scenario: Load data into a populated satellite where all records load.
    Given the TEST_STG_CUSTOMER table has data inserted into it
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And the SAT_CUSTOMER_DETAILS table has already got data
      | HASHDIFF                                              | CUSTOMER_PK | NAME    | PHONE           | DOB        | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1004\|\|ALICE\|\|17-214-233-1214\|\|1997-04-24') | md5('1001') | Alice   | 17-214-233-1214 | 1997-04-24 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1006\|\|FRIDA\|\|17-214-233-1217\|\|2018-04-13') | md5('1004') | Frida   | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |
    When I run a dbt load
    Then the SAT_CUSTOMER_DETAILS table should contain
      | HASHDIFF                                              | CUSTOMER_PK | NAME  | PHONE           | DOB        | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|1997-04-24') | md5('1001') | Alice | 17-214-233-1214 | 1997-04-24 | 1993-01-02 | 1993-01-02     | *      |
      | md5('1002\|\|BOB\|\|17-214-233-1215\|\|2006-04-17')   | md5('1002') | Bob   | 17-214-233-1215 | 2006-04-17 | 1993-01-02 | 1993-01-02     | *      |
      | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|2013-02-04')  | md5('1003') | Chad  | 17-214-233-1216 | 2013-02-04 | 1993-01-02 | 1993-01-02     | *      |
      | md5('1004\|\|DOM\|\|17-214-233-1217\|\|2018-04-13')   | md5('1004') | Dom   | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1005\|\|ERIC\|\|17-214-233-1217\|\|2018-04-13')  | md5('1005') | Eric  | 17-214-233-1217 | 2018-04-13 | 1993-01-02 | 1993-01-02     | *      |
      | md5('1006\|\|FRIDA\|\|17-214-233-1217\|\|2018-04-13') | md5('1006') | Frida | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |

  Scenario: Load data into a populated satellite where some records overlap.
    Given the TEST_STG_CUSTOMER table has data inserted into it
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And the SAT_CUSTOMER_DETAILS table has already got data
      | HASHDIFF                                              | CUSTOMER_PK | NAME    | PHONE           | DOB        | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1002\|\|BOB\|\|17-214-233-1215\|\|2006-04-17')   | md5('1002') | Bob     | 17-214-233-1215 | 2006-04-17 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|2013-02-04')  | md5('1003') | Chad    | 17-214-233-1216 | 2013-02-04 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1004\|\|ALICE\|\|17-214-233-1214\|\|1997-04-24') | md5('1001') | Alice   | 17-214-233-1214 | 1997-04-24 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1006\|\|FRIDA\|\|17-214-233-1217\|\|2018-04-13') | md5('1004') | Frida   | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |
    When I run a dbt load
    Then the SAT_CUSTOMER_DETAILS table should contain
      | HASHDIFF                                              | CUSTOMER_PK | NAME  | PHONE           | DOB        | LOADDATE   | EFFECTIVE_FROM | SOURCE |
      | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|1997-04-24') | md5('1001') | Alice | 17-214-233-1214 | 1997-04-24 | 1993-01-02 | 1993-01-02     | *      |
      | md5('1002\|\|BOB\|\|17-214-233-1215\|\|2006-04-17')   | md5('1002') | Bob   | 17-214-233-1215 | 2006-04-17 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|2013-02-04')  | md5('1003') | Chad  | 17-214-233-1216 | 2013-02-04 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1004\|\|DOM\|\|17-214-233-1217\|\|2018-04-13')   | md5('1004') | Dom   | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |
      | md5('1005\|\|ERIC\|\|17-214-233-1217\|\|2018-04-13')  | md5('1005') | Eric  | 17-214-233-1217 | 2018-04-13 | 1993-01-02 | 1993-01-02     | *      |
      | md5('1006\|\|FRIDA\|\|17-214-233-1217\|\|2018-04-13') | md5('1006') | Frida | 17-214-233-1217 | 2018-04-13 | 1993-01-01 | 1993-01-01     | *      |


# -----------------------------------------------------------------------------
# Test data load over several cyles
# -----------------------------------------------------------------------------
  Scenario: Satellite load over several cycles
    Given there is an empty TEST_STG_CUSTOMER table
    And the TEST_SAT_CUST_CUSTOMER table is empty

    # ================ DAY 1 ===================
    When the TEST_STG_CUSTOMER table has data inserted into it for day 1
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOADDATE   |
      | 1001        | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 |
      | 1002        | Beth          | 1995-08-07   | 2019-05-04     | 2019-05-04 |
      | 1003        | Charley       | 1990-02-03   | 2019-05-04     | 2019-05-04 |
      | 1010        | Jenny         | 1991-03-21   | 2019-05-04     | 2019-05-04 |
      | 1012        | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 |
    And the TEST_SAT_CUST_CUSTOMER is loaded for day 1

    # ================ DAY 2 ===================
    When the TEST_STG_CUSTOMER table has data inserted into it for day 2
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOADDATE   |
      | 1002        | Beah          | 1995-08-07   | 2019-05-05     | 2019-05-05 |
      | 1003        | Chris         | 1990-02-03   | 2019-05-05     | 2019-05-05 |
      | 1004        | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 |
      | 1010        | Jenny         | 1991-03-25   | 2019-05-05     | 2019-05-05 |
    And the TEST_SAT_CUST_CUSTOMER is loaded for day 2

    # ================ DAY 3 ===================
    When the TEST_STG_CUSTOMER table has data inserted into it for day 3
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOADDATE   |
      | 1002        | Beth          | 1995-08-07   | 2019-05-06     | 2019-05-06 |
      | 1003        | Claire        | 1990-02-03   | 2019-05-06     | 2019-05-06 |
      | 1005        | Elwyn         | 2001-07-23   | 2019-05-06     | 2019-05-06 |
      | 1006        | Freia         | 1960-01-01   | 2019-05-06     | 2019-05-06 |
    And the TEST_SAT_CUST_CUSTOMER is loaded for day 3

    # ================ DAY 4 ===================
    When the TEST_STG_CUSTOMER table has data inserted into it for day 4
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOADDATE   |
      | 1002        | Beah          | 1995-08-07   | 2019-05-07     | 2019-05-07 |
      | 1003        | Charley       | 1990-02-03   | 2019-05-07     | 2019-05-07 |
      | 1007        | Geoff         | 1990-02-03   | 2019-05-07     | 2019-05-07 |
      | 1010        | Jenny         | 1991-03-25   | 2019-05-07     | 2019-05-07 |
      | 1011        | Karen         | 1978-06-16   | 2019-05-07     | 2019-05-07 |
    And the TEST_SAT_CUST_CUSTOMER is loaded for day 4

    # =============== CHECKS ===================
    Then we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain
      | CUSTOMER_PK | HASHDIFF                             | NAME    | DOB        | EFFECTIVE_FROM | LOADDATE   | SOURCE |
      | md5('1001') | md5('1001\|\|ALBERT\|\|1990-02-03')  | Albert  | 1990-02-03 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|1995-08-07')    | Beth    | 1995-08-07 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1002\|\|BEAH\|\|1995-08-07')    | Beah    | 1995-08-07 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1002') | md5('1002\|\|BETH\|\|1995-08-07')    | Beth    | 1995-08-07 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1002') | md5('1002\|\|BEAH\|\|1995-08-07')    | Beah    | 1995-08-07 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|1990-02-03') | Charley | 1990-02-03 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1003\|\|CHRIS\|\|1990-02-03')   | Chris   | 1990-02-03 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1003') | md5('1003\|\|CLAIRE\|\|1990-02-03')  | Claire  | 1990-02-03 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1003') | md5('1003\|\|CHARLEY\|\|1990-02-03') | Charley | 1990-02-03 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1004') | md5('1004\|\|DAVID\|\|1992-01-30')   | David   | 1992-01-30 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1005') | md5('1005\|\|ELWYN\|\|2001-07-23')   | Elwyn   | 2001-07-23 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1006') | md5('1006\|\|FREIA\|\|1960-01-01')   | Freia   | 1960-01-01 | 2019-05-06     | 2019-05-06 | *      |
      | md5('1007') | md5('1007\|\|GEOFF\|\|1990-02-03')   | Geoff   | 1990-02-03 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|1991-03-21')   | Jenny   | 1991-03-21 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1010') | md5('1010\|\|JENNY\|\|1991-03-25')   | Jenny   | 1991-03-25 | 2019-05-05     | 2019-05-05 | *      |
      | md5('1011') | md5('1011\|\|KAREN\|\|1978-06-16')   | Karen   | 1978-06-16 | 2019-05-07     | 2019-05-07 | *      |
      | md5('1012') | md5('1012\|\|ALBERT\|\|1990-02-03')  | Albert  | 1990-02-03 | 2019-05-04     | 2019-05-04 | *      |
