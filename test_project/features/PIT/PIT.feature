@fixture.set_workdir
Feature: Hubs

  @fixture.PIT_load
  Scenario: Load into a pit table where the AS IS table is already established
    Given the PIT table does not exist
    And the HUB table contains data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 1993-01-01 | TPCH   |
      | md5('1002') | 1002        | 1993-01-01 | TPCH   |
    And the Sat_App table contains data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | Location   | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Portsmouth | 2019-01-01 | App    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Liverpool  | 2019-01-12 | App    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Glasgow    | 2019-01-16 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | New York   | 2019-01-01 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Phoenix    | 2019-01-08 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | San Diego  | 2019-01-20 | App    |
    And the Sat_Web table contains data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | Location   | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | London     | 2019-01-04 | WEB    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Birmingham | 2019-01-08 | WEB    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Dublin     | 2019-01-19 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Dallas     | 2019-01-06 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | El Paso    | 2019-01-08 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Las Vegas  | 2019-01-19 | WEB    |
    And the Sat_Phone table contains data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | Location   | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Swansea    | 2019-01-06 | Phone  |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Manchester | 2019-01-10 | Phone  |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Paris      | 2019-01-20 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Washington | 2019-01-03 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Austin     | 2019-01-07 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Fort Worth | 2019-01-15 | Phone  |