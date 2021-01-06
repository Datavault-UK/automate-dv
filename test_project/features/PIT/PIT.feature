@fixture.set_workdir
Feature: Hubs

  @fixture.PIT_load
  Scenario: Load into a pit table where the AS IS table is already established
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                       | T_LINKS | EFF_SATS |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS_App   |         |          |
      |              |       | SAT_CUSTOMER_DETAILS_Web   |         |          |
      |              |       | SAT_CUSTOMER_DETAILS_Phone |         |          |
    And the RAW_STAGE_APP table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Portsmouth        | 2019-01-01 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Liverpool         | 2019-01-12 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Glasgow           | 2019-01-16 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | New York          | 2019-01-01 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Phoenix           | 2019-01-08 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | San Diego         | 2019-01-20 | App    |
    And I create the STG_CUSTOMER_App stage
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | London            | 2019-01-04 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Birmingham        | 2019-01-08 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Dublin            | 2019-01-19 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Dallas            | 2019-01-06 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | El Paso           | 2019-01-08 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Las Vegas         | 2019-01-19 | WEB    |
    And I create the STG_CUSTOMER_Web stage
    And the RAW_STAGE_PHONE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Swansea           | 2019-01-06 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Manchester        | 2019-01-10 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Paris             | 2019-01-20 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Washington        | 2019-01-03 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Austin            | 2019-01-07 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Fort Worth        | 2019-01-15 | Phone  |
    And I create the STG_CUSTOMER_Phone stage
    And I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    Then the SAT_CUSTOMER_DETAILS_App table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Portsmouth        | md5('\|\|Portsmouth\|\|\|\|ALICE\|\|17-214-233-1214') | 2019-01-01     | 2019-01-01 | App    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Liverpool         | md5('\|\|Liverpool\|\|\|\|ALICE\|\|17-214-233-1214')  | 2019-01-12     | 2019-01-12 | App    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Glasgow           | md5('\|\|Glasgow\|\|\|\|ALICE\|\|17-214-233-1214')    | 2019-01-16     | 2019-01-16 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | New York          | md5('\|\|York\|\|\|\|BOB\|\|17-214-233-1215')         | 2019-01-01     | 2019-01-01 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Phoenix           | md5('\|\|Phoenix\|\|\|\|BOB\|\|17-214-233-1215')      | 2019-01-08     | 2019-01-08 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | San Diego         | md5('\|\|Diego\|\|\|\|BOB\|\|17-214-233-1215')        | 2019-01-20     | 2019-01-20 | App    |
    Then the SAT_CUSTOMER_DETAILS_Web table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | London            | md5('\|\|London\|\|\|\|ALICE\|\|17-214-233-1214')     | 2019-01-04     | 2019-01-04 | WEB    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Birmingham        | md5('\|\|Birmingham\|\|\|\|ALICE\|\|17-214-233-1214') | 2019-01-08     | 2019-01-08 | WEB    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Dublin            | md5('\|\|Dublin\|\|\|\|ALICE\|\|17-214-233-1214')     | 2019-01-19     | 2019-01-19 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Dallas            | md5('\|\|Dallas\|\|\|\|BOB\|\|17-214-233-1215')       | 2019-01-06     | 2019-01-06 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | El Paso           | md5('\|\|El Paso\|\|\|\|BOB\|\|17-214-233-1215')      | 2019-01-08     | 2019-01-08 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Las Vegas         | md5('\|\|Las Vegas\|\|\|\|BOB\|\|17-214-233-1215')    | 2019-01-19     | 2019-01-19 | WEB    |
    Then the SAT_CUSTOMER_DETAILS_Phone table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Swansea           | md5('\|\|Swansea\|\|\|\|ALICE\|\|17-214-233-1214')    | 2019-01-06     | 2019-01-06 | Phone  |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Manchester        | md5('\|\|Manchester\|\|\|\|ALICE\|\|17-214-233-1214') | 2019-01-10     | 2019-01-10 | Phone  |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Paris             | md5('\|\|Paris\|\|\|\|ALICE\|\|17-214-233-1214')      | 2019-01-20     | 2019-01-20 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Washington        | md5('\|\|Washington\|\|\|\|BOB\|\|17-214-233-1215')   | 2019-01-03     | 2019-01-03 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Austin            | md5('\|\|Austin\|\|\|\|BOB\|\|17-214-233-1215')       | 2019-01-07     | 2019-01-07 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Fort Worth        | md5('\|\|Fort Worth\|\|\|\|BOB\|\|17-214-233-1215')   | 2019-01-15     | 2019-01-15 | Phone  |
    And the AS_OF_DATES_FOR_PIT table should contain expected data
      | as_of_date |
      | 2019-01-07 |
      | 2019-01-14 |
      | 2019-01-21 |
    When I load the PIT pit