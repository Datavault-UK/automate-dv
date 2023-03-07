@not_postgres
Feature: [SAT-PM-H] Satellites Loaded using Period Materialization with hourly interval

  @fixture.satellite_cycle
  Scenario: [SAT-PM-H-01] Satellite load over several hourly cycles with insert_by_period into
  empty satellite and an inferred date range.

    Given the RAW_STAGE_TZ stage is empty
    And the SATELLITE_TZ sat is empty
    When the RAW_STAGE_TZ is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1010        | Jenny         | 1991-03-21   | 17-214-233-1217 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1012        | Albert        | 1990-02-03   | 17-214-233-1218 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1002        | Beah          | 1995-08-07   | 17-214-233-1215 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | 1003        | Chris         | 1990-02-03   | 17-214-233-1216 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | 1004        | David         | 1992-01-30   | 17-214-233-1219 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | 1010        | Jenny         | 1991-03-25   | 17-214-233-1217 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | 1003        | Claire        | 1990-02-03   | 17-214-233-1216 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | 1005        | Elwyn         | 2001-07-23   | 17-214-233-1220 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | 1006        | Freia         | 1960-01-01   | 17-214-233-1221 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | 1002        | Beah          | 1995-08-07   | 17-214-233-1215 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
      | 1007        | Geoff         | 1990-02-03   | 17-214-233-1222 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
      | 1010        | Jenny         | 1991-03-25   | 17-214-233-1217 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
      | 1011        | Karen         | 1978-06-16   | 17-214-233-1223 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with LDTS LOAD_DATE_TZ as type DATETIME2
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1217')   | 1991-03-21   | Jenny         | 17-214-233-1217 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1012') | md5('1990-02-03\|\|1012\|\|ALBERT\|\|17-214-233-1218')  | 1990-02-03   | Albert        | 17-214-233-1218 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1215')    | 1995-08-07   | Beah          | 17-214-233-1215 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHRIS\|\|17-214-233-1216')   | 1990-02-03   | Chris         | 17-214-233-1216 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID\|\|17-214-233-1219')   | 1992-01-30   | David         | 17-214-233-1219 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-25\|\|1010\|\|JENNY\|\|17-214-233-1217')   | 1991-03-25   | Jenny         | 17-214-233-1217 | 2019-08-06 02:00:00.000000 | 2019-08-06 02:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CLAIRE\|\|17-214-233-1216')  | 1990-02-03   | Claire        | 17-214-233-1216 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | md5('1005') | md5('2001-07-23\|\|1005\|\|ELWYN\|\|17-214-233-1220')   | 2001-07-23   | Elwyn         | 17-214-233-1220 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | md5('1006') | md5('1960-01-01\|\|1006\|\|FREIA\|\|17-214-233-1221')   | 1960-01-01   | Freia         | 17-214-233-1221 | 2019-08-06 03:00:00.000000 | 2019-08-06 03:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1215')    | 1995-08-07   | Beah          | 17-214-233-1215 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
      | md5('1007') | md5('1990-02-03\|\|1007\|\|GEOFF\|\|17-214-233-1222')   | 1990-02-03   | Geoff         | 17-214-233-1222 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |
      | md5('1011') | md5('1978-06-16\|\|1011\|\|KAREN\|\|17-214-233-1223')   | 1978-06-16   | Karen         | 17-214-233-1223 | 2019-08-07 04:00:00.000000 | 2019-08-07 04:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-H-02] Satellite load with hourly interval and intra-batch duplicates on base load.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 12:00:00.000000 to 2019-05-03 23:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 12:00:00.000000 to 2019-05-03 23:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |

  @bigquery
  @fixture.satellite_cycle
  Scenario: [SAT-PM-H-03] Satellite load with hourly interval and intra-batch duplicates on incremental load.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 23:00:00.000000 | 2019-05-03 23:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 03:00:00.000000 | 2019-05-04 03:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 03:00:00.000000 | 2019-05-04 03:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 23:00:00.000000 to 2019-05-04 04:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 23:00:00.000000 | 2019-05-03 23:00:00.000000 | *      |
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 23:00:00.000000 to 2019-05-04 04:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 23:00:00.000000 | 2019-05-03 23:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 03:00:00.000000 | 2019-05-04 03:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-H-04] Satellite load with hourly interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 04:00:00.000000 | 2019-05-03 04:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 04:00:00.000000 | 2019-05-03 04:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 07:00:00.000000 | 2019-05-03 07:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 10:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 10:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 04:00:00.000000 | 2019-05-03 04:00:00.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 04:00:00.000000 | 2019-05-03 04:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-H-05] Satellite load with hourly interval and intra-batch base load and intra-load duplicates
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 03:00:00.000000 | 2019-05-03 03:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 03:00:00.000000 | 2019-05-03 03:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 03:00:00.000000 | 2019-05-03 03:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 07:00:00.000000 | 2019-05-03 07:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 07:00:00.000000 | 2019-05-03 07:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 10:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 10:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 03:00:00.000000 | 2019-05-03 03:00:00.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 07:00:00.000000 | 2019-05-03 07:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-H-06] Satellite load with hourly interval, loading with different stage data
    And the SATELLITE_TZ sat is empty
    When the RAW_STAGE_TZ is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 23:00:00.000000 | 2019-05-03 23:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 01:00:00.000000 | 2019-05-04 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 23:00:00.000000 to 2019-05-04 03:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 23:00:00.000000 | 2019-05-03 23:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 01:00:00.000000 | 2019-05-04 01:00:00.000000 | *      |
    When the RAW_STAGE_TZ is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 06:00:00.000000 | 2019-05-04 02:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 2019-05-03 23:00:00.000000 to 2019-05-04 06:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 23:00:00.000000 | 2019-05-03 23:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 01:00:00.000000 | 2019-05-04 01:00:00.000000 | *      |

  @fixture.satellite
  Scenario: [SAT-PM-B-H-07] Base load of a satellite with one value in rank column loads first rank
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 02:00:00.000000 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 04:00:00.000000 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 02:00:00.000000 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 02:00:00.000000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 02:00:00.000000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 04:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with date range: 1993-01-01 02:00:00.000000 to 1993-01-01 06:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 02:00:00.000000 | 1993-01-01 02:00:00.000000 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 02:00:00.000000 | 1993-01-01 02:00:00.000000 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 02:00:00.000000 | 1993-01-01 02:00:00.000000 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 02:00:00.000000 | 1993-01-01 02:00:00.000000 | *      |

  @fixture.satellite
  Scenario: [SAT-PM-H-08] Incremental load of empty satellite using insert by period and additional columns
    Given the SATELLITE_AC_TZ sat is empty
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE_TZ               | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | TPCH_CUSTOMER  | 1993-01-01 03:00:00.000000 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-01 05:00:00.000000 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-01 05:00:00.000000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-01 07:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_AC_TZ sat by hour with date range: 1993-01-01 02:00:00.000000 to 1993-01-01 12:00:00.000000 and LDTS LOAD_DATE_TZ with type TIMESTAMP
    Then the SATELLITE_AC_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_MT_ID | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | TPCH_CUSTOMER  | 1993-01-01 03:00:00.000000 | 1993-01-01 03:00:00.000000 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | TPCH_CUSTOMER  | 1993-01-01 05:00:00.000000 | 1993-01-01 05:00:00.000000 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | TPCH_CUSTOMER  | 1993-01-01 05:00:00.000000 | 1993-01-01 05:00:00.000000 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | TPCH_CUSTOMER  | 1993-01-01 07:00:00.000000 | 1993-01-01 07:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-H-09] Satellite load over several hourly cycles with insert_by_period into populated satellite, with partial duplicates.
    Given the RAW_STAGE_TZ stage is empty
    And the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1201')  | Albert        | 1990-02-03   | 17-214-233-1201 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1202')    | Beth          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1203') | Charley       | 1990-02-03   | 17-214-233-1203 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1210')   | Jenny         | 1991-03-21   | 17-214-233-1210 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1012') | md5('1990-02-03\|\|1012\|\|ALBERT\|\|17-214-233-1212')  | Albert        | 1990-02-03   | 17-214-233-1212 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1202')    | Beah          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHRIS\|\|17-214-233-1203')   | Chris         | 1990-02-03   | 17-214-233-1203 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID\|\|17-214-233-1204')   | David         | 1992-01-30   | 17-214-233-1204 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-25\|\|1010\|\|JENNY\|\|17-214-233-1210')   | Jenny         | 1991-03-25   | 17-214-233-1210 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1202')    | Beth          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CLAIRE\|\|17-214-233-1203')  | Claire        | 1990-02-03   | 17-214-233-1203 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1005') | md5('2001-07-23\|\|1005\|\|ELWYN\|\|17-214-233-1205')   | Elwyn         | 2001-07-23   | 17-214-233-1205 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1006') | md5('1960-01-01\|\|1006\|\|FREIA\|\|17-214-233-1206')   | Freia         | 1960-01-01   | 17-214-233-1206 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1202')    | Beah          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1203') | Charley       | 1990-02-03   | 17-214-233-1203 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | md5('1007') | md5('1990-02-03\|\|1007\|\|GEOFF\|\|17-214-233-1207')   | Geoff         | 1990-02-03   | 17-214-233-1207 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | md5('1011') | md5('1978-06-16\|\|1011\|\|KAREN\|\|17-214-233-1211')   | Karen         | 1978-06-16   | 17-214-233-1211 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
    When the RAW_STAGE_TZ is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | 1002        | Beah          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1203 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | 1007        | Geoff         | 1990-02-03   | 17-214-233-1207 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | 1010        | Jenny         | 1991-03-25   | 17-214-233-1210 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | 1011        | Karen         | 1978-06-16   | 17-214-233-1211 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | 1013        | Zach          | 1995-06-16   | 17-214-233-1213 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I insert by period into the SATELLITE_TZ sat by hour with LDTS LOAD_DATE_TZ as type TIMESTAMP
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM_TZ          | LOAD_DATE_TZ               | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1201')  | Albert        | 1990-02-03   | 17-214-233-1201 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1202')    | Beth          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1203') | Charley       | 1990-02-03   | 17-214-233-1203 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1210')   | Jenny         | 1991-03-21   | 17-214-233-1210 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1012') | md5('1990-02-03\|\|1012\|\|ALBERT\|\|17-214-233-1212')  | Albert        | 1990-02-03   | 17-214-233-1212 | 2019-05-04 04:00:00.000000 | 2019-05-04 04:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1202')    | Beah          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHRIS\|\|17-214-233-1203')   | Chris         | 1990-02-03   | 17-214-233-1203 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID\|\|17-214-233-1204')   | David         | 1992-01-30   | 17-214-233-1204 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-25\|\|1010\|\|JENNY\|\|17-214-233-1210')   | Jenny         | 1991-03-25   | 17-214-233-1210 | 2019-05-04 05:00:00.000000 | 2019-05-04 05:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1202')    | Beth          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CLAIRE\|\|17-214-233-1203')  | Claire        | 1990-02-03   | 17-214-233-1203 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1005') | md5('2001-07-23\|\|1005\|\|ELWYN\|\|17-214-233-1205')   | Elwyn         | 2001-07-23   | 17-214-233-1205 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1006') | md5('1960-01-01\|\|1006\|\|FREIA\|\|17-214-233-1206')   | Freia         | 1960-01-01   | 17-214-233-1206 | 2019-05-04 06:00:00.000000 | 2019-05-04 06:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1202')    | Beah          | 1995-08-07   | 17-214-233-1202 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1203') | Charley       | 1990-02-03   | 17-214-233-1203 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | md5('1007') | md5('1990-02-03\|\|1007\|\|GEOFF\|\|17-214-233-1207')   | Geoff         | 1990-02-03   | 17-214-233-1207 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | md5('1011') | md5('1978-06-16\|\|1011\|\|KAREN\|\|17-214-233-1211')   | Karen         | 1978-06-16   | 17-214-233-1211 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
      | md5('1013') | md5('1995-06-16\|\|1013\|\|ZACH\|\|17-214-233-1213')    | Zach          | 1995-06-16   | 17-214-233-1213 | 2019-05-04 07:00:00.000000 | 2019-05-04 07:00:00.000000 | *      |
