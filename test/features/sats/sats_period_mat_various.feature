Feature: [SAT-PM-V] Typical Satellite Loaded, with period_mat_various scenarios

  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-01] Satellite load with microsecond interval will return an error.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 01:00:00.000005 | 2019-05-03 01:00:00.000005 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:00.000005 | 2019-05-03 01:00:00.000005 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:00.000007 | 2019-05-03 01:00:00.000007 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And if I insert by period into the SATELLITE_TZ sat by microsecond this will fail with "This datepart" error
    #failing
  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-02] Satellite load with millisecond interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 01:00:00.005000 | 2019-05-03 01:00:00.005000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:00.005000 | 2019-05-03 01:00:00.005000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:00.007000 | 2019-05-03 01:00:00.007000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    #And I insert by period into the SATELLITE_TZ sat by millisecond with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 01:00:00.009000 and LDTS LOAD_DATE
    And I load the SATELLITE sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    #And I insert by period into the SATELLITE_TZ sat by millisecond with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 01:00:00.009000 and LDTS LOAD_DATE
    And I load the SATELLITE sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 01:00:00.005000 | 2019-05-03 01:00:00.005000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:00.005000 | 2019-05-03 01:00:00.005000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-03] Satellite load with second interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 01:00:05.000000 | 2019-05-03 01:00:05.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:05.000000 | 2019-05-03 01:00:05.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:09.000000 | 2019-05-03 01:00:09.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    #And I insert by period into the SATELLITE_TZ sat by second with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 01:00:10.000000 and LDTS LOAD_DATE
    And I load the SATELLITE sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    #And I insert by period into the SATELLITE_TZ sat by second with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 01:00:10.000000 and LDTS LOAD_DATE
    And I load the SATELLITE sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 01:00:05.000000 | 2019-05-03 01:00:05.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:00:05.000000 | 2019-05-03 01:00:05.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-04] Satellite load with minute interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 01:05:00.000000 | 2019-05-03 01:05:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:05:00.000000 | 2019-05-03 01:05:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:10:00.000000 | 2019-05-03 01:10:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    #And I insert by period into the SATELLITE_TZ sat by minute with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 01:11:00.000000 and LDTS LOAD_DATE
    And I load the SATELLITE sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    And I load the SATELLITE sat
      #And I insert by period into the SATELLITE_TZ sat by minute with date range: 2019-05-03 01:00:00.000000 to 2019-05-03 01:11:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-03 01:05:00.000000 | 2019-05-03 01:05:00.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-03 01:05:00.000000 | 2019-05-03 01:05:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-05] Satellite load with week interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-10 01:00:00.000000 | 2019-05-10 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-10 01:00:00.000000 | 2019-05-10 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-17 01:00:00.000000 | 2019-05-17 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE sat
      #And I insert by period into the SATELLITE_TZ sat by week with date range: 2019-05-03 01:00:00.000000 to 2019-05-24 01:10:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    And I insert by period into the SATELLITE_TZ sat by week with date range: 2019-05-03 01:00:00.000000 to 2019-05-24 01:00:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-10 01:00:00.000000 | 2019-05-10 01:00:00.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-10 01:00:00.000000 | 2019-05-10 01:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-06] Satellite load with month interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-06-05 01:00:00.000000 | 2019-06-05 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-06-05 01:00:00.000000 | 2019-06-05 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-07-03 01:00:00.000000 | 2019-07-03 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE sat
      #And I insert by period into the SATELLITE_TZ sat by month with date range: 2019-05-03 01:00:00.000000 to 2019-07-03 01:00:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    And I load the SATELLITE sat
    #And I insert by period into the SATELLITE_TZ sat by month with date range: 2019-05-03 01:00:00.000000 to 2019-07-03 01:00:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-06-05 01:00:00.000000 | 2019-06-05 01:00:00.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-06-05 01:00:00.000000 | 2019-06-05 01:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-07] Satellite load with quarter interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-08-03 01:00:00.000000 | 2019-08-03 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-08-03 01:00:00.000000 | 2019-08-03 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-11-03 01:00:00.000000 | 2019-11-03 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE sat
      #And I insert by period into the SATELLITE_TZ sat by quarter with date range: 2019-05-03 01:00:00.000000 to 2020-05-03 01:00:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    And I load the SATELLITE sat
      #And I insert by period into the SATELLITE_TZ sat by quarter with date range: 2019-05-03 01:00:00.000000 to 2020-05-03 01:00:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-08-03 01:00:00.000000 | 2019-08-03 01:00:00.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-08-03 01:00:00.000000 | 2019-08-03 01:00:00.000000 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-V-08] Satellite load with yearly interval and intra-load duplicates.
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2020-08-03 01:00:00.000000 | 2020-08-03 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2020-08-03 01:00:00.000000 | 2020-08-03 01:00:00.000000 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2021-11-03 01:00:00.000000 | 2021-11-03 01:00:00.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE sat
      #And I insert by period into the SATELLITE_TZ sat by year with date range: 2019-05-03 01:00:00.000000 to 2022-05-03 01:00:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
    And I insert by period into the SATELLITE_TZ sat by year with date range: 2019-05-03 01:00:00.000000 to 2022-05-03 01:00:00.000000 and LDTS LOAD_DATE
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 01:00:00.000000 | 2019-05-03 01:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2020-08-03 01:00:00.000000 | 2020-08-03 01:00:00.000000 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2020-08-03 01:00:00.000000 | 2020-08-03 01:00:00.000000 | *      |