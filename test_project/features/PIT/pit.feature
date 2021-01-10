@fixture.set_workdir
Feature: pit

  @fixture.pit
  Scenario: Load into a pit table where the AS IS table is already established Where the AS_IS table has increments of a week
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                       | T_LINKS | EFF_SATS | PIT          |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS_APP   |         |          | PIT_CUSTOMER |
      |              |       | SAT_CUSTOMER_DETAILS_WEB   |         |          |              |
      |              |       | SAT_CUSTOMER_DETAILS_PHONE |         |          |              |
    And the RAW_STAGE_APP table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Portsmouth        | 2019-01-01 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Liverpool         | 2019-01-12 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Glasgow           | 2019-01-16 | App    |
      | 1002        | Bob           | 17-214-233-1w215 | 2006-04-17   | New York          | 2019-01-01 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Phoenix           | 2019-01-08 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | San Diego         | 2019-01-20 | App    |
    And I create the STG_CUSTOMER_APP stage
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | London            | 2019-01-04 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Birmingham        | 2019-01-08 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Dublin            | 2019-01-19 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Dallas            | 2019-01-06 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | El Paso           | 2019-01-09 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Las Vegas         | 2019-01-19 | WEB    |
    And I create the STG_CUSTOMER_WEB stage
    And the RAW_STAGE_PHONE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Swansea           | 2019-01-06 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Manchester        | 2019-01-10 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Paris             | 2019-01-20 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Washington        | 2019-01-03 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Austin            | 2019-01-07 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Fort Worth        | 2019-01-15 | Phone  |
    And I create the STG_CUSTOMER_PHONE stage
    And the AS_OF_DATE table contains data
      | as_of_date |
      | 2019-01-07 |
      | 2019-01-14 |
      | 2019-01-21 |
    When I load the vault
    Then the HUB_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | 1001        | 2019-01-01 | App    |
      | md5('1002') | 1002        | 2019-01-01 | App    |
    Then the SAT_CUSTOMER_DETAILS_APP table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | HASHDIFF                                      | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Portsmouth        | md5('PORTSMOUTH\|\|ALICE\|\|17-214-233-1214') | 2019-01-01     | 2019-01-01 | App    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Liverpool         | md5('LIVERPOOL\|\|ALICE\|\|17-214-233-1214')  | 2019-01-12     | 2019-01-12 | App    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Glasgow           | md5('GLASGOW\|\|ALICE\|\|17-214-233-1214')    | 2019-01-16     | 2019-01-16 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | New York          | md5('NEW YORK\|\|BOB\|\|17-214-233-1215')     | 2019-01-01     | 2019-01-01 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Phoenix           | md5('PHOENIX\|\|BOB\|\|17-214-233-1215')      | 2019-01-08     | 2019-01-08 | App    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | San Diego         | md5('SAN DIEGO\|\|BOB\|\|17-214-233-1215')    | 2019-01-20     | 2019-01-20 | App    |
    Then the SAT_CUSTOMER_DETAILS_WEB table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | HASHDIFF                                      | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | London            | md5('LONDON\|\|ALICE\|\|17-214-233-1214')     | 2019-01-04     | 2019-01-04 | WEB    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Birmingham        | md5('BIRMINGHAM\|\|ALICE\|\|17-214-233-1214') | 2019-01-08     | 2019-01-08 | WEB    |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Dublin            | md5('DUBLIN\|\|ALICE\|\|17-214-233-1214')     | 2019-01-19     | 2019-01-19 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Dallas            | md5('DALLAS\|\|BOB\|\|17-214-233-1215')       | 2019-01-06     | 2019-01-06 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | El Paso           | md5('EL PASO\|\|BOB\|\|17-214-233-1215')      | 2019-01-09     | 2019-01-09 | WEB    |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Las Vegas         | md5('LAS VEGAS\|\|BOB\|\|17-214-233-1215')    | 2019-01-19     | 2019-01-19 | WEB    |
    Then the SAT_CUSTOMER_DETAILS_PHONE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | HASHDIFF                                      | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Swansea           | md5('SWANSEA\|\|ALICE\|\|17-214-233-1214')    | 2019-01-06     | 2019-01-06 | Phone  |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Manchester        | md5('MANCHESTER\|\|ALICE\|\|17-214-233-1214') | 2019-01-10     | 2019-01-10 | Phone  |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | Paris             | md5('PARIS\|\|ALICE\|\|17-214-233-1214')      | 2019-01-20     | 2019-01-20 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Washington        | md5('WASHINGTON\|\|BOB\|\|17-214-233-1215')   | 2019-01-03     | 2019-01-03 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Austin            | md5('AUSTIN\|\|BOB\|\|17-214-233-1215')       | 2019-01-07     | 2019-01-07 | Phone  |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | Fort Worth        | md5('FORT WORTH\|\|BOB\|\|17-214-233-1215')   | 2019-01-15     | 2019-01-15 | Phone  |
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_APP_PK | SAT_CUSTOMER_DETAILS_APP_LDTS | SAT_CUSTOMER_DETAILS_WEB_PK | SAT_CUSTOMER_DETAILS_WEB_LDTS | SAT_CUSTOMER_DETAILS_PHONE_PK | SAT_CUSTOMER_DETAILS_PHONE_LDTS |
      | md5('1001') | 2019-01-07 | md5('1001')                 | 2019-01-01                    | md5('1001')                 | 2019-01-04                    | md5('1001')                   | 2019-01-06                      |
      | md5('1001') | 2019-01-14 | md5('1001')                 | 2019-01-12                    | md5('1001')                 | 2019-01-08                    | md5('1001')                   | 2019-01-10                      |
      | md5('1001') | 2019-01-21 | md5('1001')                 | 2019-01-16                    | md5('1001')                 | 2019-01-19                    | md5('1001')                   | 2019-01-20                      |
      | md5('1002') | 2019-01-07 | md5('1002')                 | 2019-01-01                    | md5('1002')                 | 2019-01-06                    | md5('1002')                   | 2019-01-03                      |
      | md5('1002') | 2019-01-14 | md5('1002')                 | 2019-01-08                    | md5('1002')                 | 2019-01-09                    | md5('1002')                   | 2019-01-07                      |
      | md5('1002') | 2019-01-21 | md5('1002')                 | 2019-01-20                    | md5('1002')                 | 2019-01-19                    | md5('1002')                   | 2019-01-15                      |

  @fixture.pit
  Scenario: Load into a pit table where the AS IS table is already established but the final pit table will deal with NULL Values as ghosts
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                       | T_LINKS | EFF_SATS | PITS         |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS_App   |         |          | PIT_Customer |
      |              |       | SAT_CUSTOMER_DETAILS_Web   |         |          |              |
      |              |       | SAT_CUSTOMER_DETAILS_Phone |         |          |              |
    And the RAW_STAGE_APP table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Portsmouth        | 2019-01-01 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Liverpool         | 2019-01-12 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Glasgow           | 2019-01-14 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | New York          | 2019-01-01 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Phoenix           | 2019-01-08 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | San Diego         | 2019-01-20 | App    |
    And I create the STG_CUSTOMER_App stage
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | London            | 2019-01-04 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Birmingham        | 2019-01-08 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Dublin            | 2019-01-19 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Las Vegas         | 2019-01-19 | WEB    |
    And I create the STG_CUSTOMER_Web stage
    And the RAW_STAGE_PHONE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Swansea           | 2019-01-05 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Manchester        | 2019-01-06 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Paris             | 2019-01-20 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Washington        | 2019-01-03 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Austin            | 2019-01-07 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Fort Worth        | 2019-01-15 | Phone  |
    And I create the STG_CUSTOMER_Phone stage
    And the AS_OF_DATES table contains data
      | as_of_date |
      | 2019-01-07 |
      | 2019-01-07 |
      | 2019-01-14 |
      | 2019-01-21 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_Phone_PK | SAT_CUSTOMER_DETAILS_App_LDTS | SAT_CUSTOMER_DETAILS_Web_PK | SAT_CUSTOMER_DETAILS_Web_LDTS | SAT_CUSTOMER_DETAILS_Phone_PK | SAT_CUSTOMER_DETAILS_Phone_LDTS |
      | 1001        | 2019-01-07 | md5('1001')                   | 2019-01-01                    | md5('1001')                 | 2019-01-04                    | md5('1001')                   | 2019-01-05                      |
      | 1001        | 2019-01-14 | md5('1001')                   | 2019-01-12                    | md5('1001')                 | 2019-01-08                    | md5('1001')                   | 2019-01-06                      |
      | 1001        | 2019-01-21 | md5('1001')                   | 2019-01-14                    | md5('1001')                 | 2019-01-19                    | md5('1001')                   | 2019-01-20                      |
      | 1002        | 2019-01-07 | md5('1002')                   | 2019-01-01                    |                             |                               | md5('1002')                   | 2019-01-07                      |
      | 1002        | 2019-01-14 | md5('1002')                   | 2019-01-08                    |                             |                               | md5('1002')                   |                                 |
      | 1002        | 2019-01-21 | md5('1002')                   | 2019-01-20                    | md5('1002')                 | 2019-01-19                    | md5('1002')                   | 2019-01-15                      |


  @fixture.pit
  Scenario: Load into a pit table where the AS IS table is already established and the AS IS table has increments of 30 mins
    Given the PIT table does not exist
    And the raw vault contains empty tables
      | HUBS         | LINKS | SATS                       | T_LINKS | EFF_SATS | PITS         |
      | HUB_CUSTOMER |       | SAT_CUSTOMER_DETAILS_App   |         |          | PIT_Customer |
      |              |       | SAT_CUSTOMER_DETAILS_Web   |         |          |              |
      |              |       | SAT_CUSTOMER_DETAILS_Phone |         |          |              |
    And the RAW_STAGE_APP table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Portsmouth        | 2019-01-01 10:22:00 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Liverpool         | 2019-01-01 10:44:00 | App    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Glasgow           | 2019-01-01 11:12:00 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | New York          | 2019-01-01 10:16:00 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Phoenix           | 2019-01-01 10:52:00 | App    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | San Diego         | 2019-01-01 11:01:00 | App    |
    And I create the STG_CUSTOMER_App stage
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | London            | 2019-01-01 10:16:00 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Birmingham        | 2019-01-01 10:56:00 | WEB    |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Dublin            | 2019-01-01 11:22:00 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Dallas            | 2019-01-01 10:07:00 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | El Paso           | 2019-01-01 10:49:00 | WEB    |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Las Vegas         | 2019-01-01 11:28:00 | WEB    |
    And I create the STG_CUSTOMER_Web stage
    And the RAW_STAGE_PHONE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_LOCATION | LOAD_DATE           | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Swansea           | 2019-01-01 10:09:00 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Manchester        | 2019-01-01 10:38:00 | Phone  |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | Paris             | 2019-01-01 11:08:00 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Washington        | 2019-01-01 10:22:00 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Austin            | 2019-01-01 10:38:00 | Phone  |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | Fort Worth        | 2019-01-01 11:17:00 | Phone  |
    And I create the STG_CUSTOMER_Phone stage
    And the AS_OF_DATES table contains data
      | as_of_date          |
      | 2019-01-01 10:30:00 |
      | 2019-01-01 11:00:00 |
      | 2019-01-01 11:30:00 |
    When I load the vault
    Then the PIT_CUSTOMER table should contain expected data
      | CUSTOMER_PK | AS_OF_DATE | SAT_CUSTOMER_DETAILS_PHONE_PK | SAT_CUSTOMER_DETAILS_APP_LDTS | SAT_CUSTOMER_DETAILS_WEB_PK | SAT_CUSTOMER_DETAILS_WEB_LDTS | SAT_CUSTOMER_DETAILS_PHONE_PK | SAT_CUSTOMER_DETAILS_PHONE_LDTS |
      | 1001        | 2019-01-07 | md5('1001')                   | 2019-01-01 10:22:00           | md5('1001')                 | 2019-01-01 10:16:00           | md5('1001')                   | 2019-01-01 10:09:00             |
      | 1001        | 2019-01-14 | md5('1001')                   | 2019-01-01 10:44:00           | md5('1001')                 | 2019-01-01 10:56:00           | md5('1001')                   | 2019-01-01 10:38:00             |
      | 1001        | 2019-01-21 | md5('1001')                   | 2019-01-01 11:12:00           | md5('1001')                 | 2019-01-01 11:22:00           | md5('1001')                   | 2019-01-01 11:08:00             |
      | 1002        | 2019-01-07 | md5('1002')                   | 2019-01-01 10:16:00           | md5('1002')                 | 2019-01-01 10:07:00           | md5('1002')                   | 2019-01-01 10:22:00             |
      | 1002        | 2019-01-14 | md5('1002')                   | 2019-01-01 10:52:00           | md5('1002')                 | 2019-01-01 10:49:00           | md5('1002')                   | 2019-01-01 10:38:00             |
      | 1002        | 2019-01-21 | md5('1002')                   | 2019-01-01 11:01:00           | md5('1002')                 | 2019-01-01 11:28:00           | md5('1002')                   | 2019-01-01 11:17:00             |