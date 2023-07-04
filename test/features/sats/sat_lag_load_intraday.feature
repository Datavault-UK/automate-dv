Feature: [SAT-LL-ID] Satellites Loaded using Period Materialization with hourly interval

  @fixture.satellite
  Scenario: [SAT-LL-ID-01] Incremental load into non existent sat with timestamp, with first and only record different to latest
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |
    And I stage the STG_CUSTOMER_TZ data
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1217')   | 1991-03-21   | Jenny         | 17-214-233-1217 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |

  @fixture.satellite
  Scenario: [SAT-LL-ID-02] Incremental load into non existent sat with timestamp, with first two incrememntal records of same hashdiff
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |
      | 1001        | Albie          | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000002 | *      |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000003 | *      |
    And I stage the STG_CUSTOMER_TZ data
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1217')   | 1991-03-21   | Jenny         | 17-214-233-1217 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000003 | 2019-08-06 01:00:00.000003 | *      |

  @fixture.satellite
  Scenario: [SAT-LL-ID-03] Incremental load into non existent sat with timestamp, with flip flop hashdiff
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |
      | 1001        | Alby          | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000002 | *      |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000003 | *      |
    And I stage the STG_CUSTOMER_TZ data
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1217')   | 1991-03-21   | Jenny         | 17-214-233-1217 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBY\|\|17-214-233-1214')    | 1990-02-03   | Alby          | 17-214-233-1214 | 2019-08-06 01:00:00.000002 | 2019-08-06 01:00:00.000002 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000003 | 2019-08-06 01:00:00.000003 | *      |

  Scenario: [SAT-LL-ID-03] Incremental load into non existent sat with timestamp, with flip flop hashdiff and duplicate
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000002 | *      |
      | 1001        | Alby          | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000003 | *      |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000004 | *      |
    And I stage the STG_CUSTOMER_TZ data
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1217')   | 1991-03-21   | Jenny         | 17-214-233-1217 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.000001 | 2019-08-06 01:00:00.000001 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBY\|\|17-214-233-1214')    | 1990-02-03   | Alby          | 17-214-233-1214 | 2019-08-06 01:00:00.000003 | 2019-08-06 01:00:00.000003 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000004 | 2019-08-06 01:00:00.000004 | *      |

