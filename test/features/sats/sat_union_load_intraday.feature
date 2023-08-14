Feature: [SAT-LL-ID] Loading intra day non existent satellites, with new "union" loading scheme

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
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |

  @fixture.satellite
  Scenario: [SAT-LL-ID-02] Incremental load into non existent sat with timestamp, with first two incremental records of same hashdiff
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
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.200000 | 2019-08-06 01:00:00.200000 | *      |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.300000 | 2019-08-06 01:00:00.300000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.300000 | 2019-08-06 01:00:00.300000 | *      |

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
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |
      | 1001        | Alby          | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.200000 | 2019-08-06 01:00:00.200000 | *      |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.300000 | 2019-08-06 01:00:00.300000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBY\|\|17-214-233-1214')    | 1990-02-03   | Alby          | 17-214-233-1214 | 2019-08-06 01:00:00.200000 | 2019-08-06 01:00:00.200000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.300000 | 2019-08-06 01:00:00.300000 | *      |

  @fixture.satellite
  Scenario: [SAT-LL-ID-04] Incremental load into non existent sat with timestamp, with flip flop hashdiff and duplicate
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
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |
      | 1001        | Albie         | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.200000 | 2019-08-06 01:00:00.200000 | *      |
      | 1001        | Alby          | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.300000 | 2019-08-06 01:00:00.300000 | *      |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-08-06 01:00:00.400000 | 2019-08-06 01:00:00.400000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-08-06 01:00:00.000000 | 2019-08-06 01:00:00.000000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBIE\|\|17-214-233-1214')   | 1990-02-03   | Albie         | 17-214-233-1214 | 2019-08-06 01:00:00.100000 | 2019-08-06 01:00:00.100000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBY\|\|17-214-233-1214')    | 1990-02-03   | Alby          | 17-214-233-1214 | 2019-08-06 01:00:00.300000 | 2019-08-06 01:00:00.300000 | *      |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-08-06 01:00:00.400000 | 2019-08-06 01:00:00.400000 | *      |

