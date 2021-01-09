@fixture.set_workdir
Feature: Satellites Loaded using Rank Materialization

  @fixture.enable_full_refresh
  @fixture.satellite_cycle
  Scenario: [SAT-RANK-MAT] Base load of a satellite using full refresh should only contain first rank records
    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                             | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT')  | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH')    | Beth          | 1995-08-07   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY') | Charley       | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1004        | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 | *      |
    And I create the STG_CUSTOMER stage
    And I insert by rank into the SATELLITE sat by day with date range: 2019-05-05 to 2019-05-06
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                           | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID') | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 | *      |