Feature: [SAT] Sats loaded using Incremental Materialization and checking for idempotency

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-01] Idempotent loads on non existent sat with single record per PK
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    And I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite_cycle
  Scenario: [SAT-ID-IM-02] Idempotent intra day satellite load - 2 cycles - second cycle is entirely duplicated
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
    And I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite_cycle
  Scenario: [SAT-ID-IM-03] Idempotent intra day satellite load
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1215 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1215') | Carl          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1215') | Carl          | 1995-08-08   | 17-214-233-1215 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1215') | Carl          | 1995-08-07   | 17-214-233-1215 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1215') | Carl          | 1995-08-08   | 17-214-233-1215 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-04] Idempotent test loading existing records anda single new record into populated satellite - one cycle
    Given the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1004') | md5('1995-08-09\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-05] Idempotent test loading existing with a multiple new records into populated satellite - two cycles, second cycle duplicates first
    Given the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1004') | md5('1995-08-09\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-06] Idempotent test loading existing with a multiple new records into populated satellite - two cycles, second cycle duplicates first AND adds new
    Given the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
      | 1005        | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1004') | md5('1995-08-09\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
      | md5('1005') | md5('1995-08-10\|\|1005\|\|ELLEN\|\|17-214-233-1218') | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-07] Idempotent test loading existing with a multiple new records into populated satellite - two cycles, second cycle only adds new on same ldts
    Given the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1005        | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | 1006        | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | 1007        | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1004') | md5('1995-08-09\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
      | md5('1005') | md5('1995-08-10\|\|1005\|\|ELLEN\|\|17-214-233-1218') | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | md5('1006') | md5('1995-08-11\|\|1006\|\|FELIX\|\|17-214-233-1219') | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | md5('1007') | md5('1995-08-12\|\|1007\|\|GEMMA\|\|17-214-233-1220') | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-08] Idempotent test loading existing with a multiple new records into populated satellite - two cycles, second cycle only adds new on different ldts
    Given the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1005        | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | 1006        | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | 1007        | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1004') | md5('1995-08-09\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
      | md5('1005') | md5('1995-08-10\|\|1005\|\|ELLEN\|\|17-214-233-1218') | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | md5('1006') | md5('1995-08-11\|\|1006\|\|FELIX\|\|17-214-233-1219') | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | md5('1007') | md5('1995-08-12\|\|1007\|\|GEMMA\|\|17-214-233-1220') | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-09] Idempotent test loading existing with a multiple new records into populated satellite - two cycles, second cycle adds new on different ldts with duplicates
    Given the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1005        | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | 1005        | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | 1006        | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | 1006        | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | 1007        | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |
      | 1007        | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1004') | md5('1995-08-09\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
      | md5('1005') | md5('1995-08-10\|\|1005\|\|ELLEN\|\|17-214-233-1218') | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | md5('1006') | md5('1995-08-11\|\|1006\|\|FELIX\|\|17-214-233-1219') | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | md5('1007') | md5('1995-08-12\|\|1007\|\|GEMMA\|\|17-214-233-1220') | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-10] Idempotent test loading existing with a multiple new records into populated satellite - two cycles, second cycle adds new on different ldts with only hashdiff changes
    Given the SATELLITE_TZ sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                             | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216') | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | 1002        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | 1003        | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | 1003        | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | 1004        | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | 1005        | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | 1005        | Ellen         | 1995-08-10   | 17-214-233-1228 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | 1006        | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | 1006        | Felix         | 1995-08-11   | 17-214-233-1229 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | 1007        | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |
      | 1007        | Gemma         | 1995-08-12   | 17-214-233-1230 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |
    And I stage the STG_CUSTOMER_TZ data
    And I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM             | LOAD_DATE                  | SOURCE |
      | md5('1003') | md5('1995-08-07\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-07   | 17-214-233-1216 | 2019-05-04 12:00:00.000000 | 2019-05-04 12:00:00.000000 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03 12:00:00.000000 | 2019-05-03 12:00:00.000000 | *      |
      | md5('1003') | md5('1995-08-08\|\|1003\|\|CARL\|\|17-214-233-1216')  | Carl          | 1995-08-08   | 17-214-233-1216 | 2019-05-04 12:00:01.000000 | 2019-05-04 12:00:01.000000 | *      |
      | md5('1002') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215')  | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-03 12:00:01.000000 | 2019-05-03 12:00:01.000000 | *      |
      | md5('1004') | md5('1995-08-09\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1995-08-09   | 17-214-233-1217 | 2019-05-05 12:00:01.000000 | 2019-05-05 12:00:01.000000 | *      |
      | md5('1005') | md5('1995-08-10\|\|1005\|\|ELLEN\|\|17-214-233-1218') | Ellen         | 1995-08-10   | 17-214-233-1218 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | md5('1005') | md5('1995-08-10\|\|1005\|\|ELLEN\|\|17-214-233-1228') | Ellen         | 1995-08-10   | 17-214-233-1228 | 2019-05-06 12:00:01.000000 | 2019-05-06 12:00:01.000000 | *      |
      | md5('1006') | md5('1995-08-11\|\|1006\|\|FELIX\|\|17-214-233-1219') | Felix         | 1995-08-11   | 17-214-233-1219 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | md5('1006') | md5('1995-08-11\|\|1006\|\|FELIX\|\|17-214-233-1229') | Felix         | 1995-08-11   | 17-214-233-1229 | 2019-05-07 12:00:01.000000 | 2019-05-07 12:00:01.000000 | *      |
      | md5('1007') | md5('1995-08-12\|\|1007\|\|GEMMA\|\|17-214-233-1220') | Gemma         | 1995-08-12   | 17-214-233-1220 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |
      | md5('1007') | md5('1995-08-12\|\|1007\|\|GEMMA\|\|17-214-233-1230') | Gemma         | 1995-08-12   | 17-214-233-1230 | 2019-05-08 12:00:01.000000 | 2019-05-08 12:00:01.000000 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-11] Idempotent loads on non existent sat with single record per PK, with a composite PK
    Given the SATELLITE_COMP table does not exist
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | A        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | B        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the SATELLITE_COMP sat
    And I load the SATELLITE_COMP sat
    Then the SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                   | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('A') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214\|\|A') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('B') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215\|\|B')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.apply_stage_filter
  @fixture.satellite
  Scenario: [SAT-ID-IM-12] Idempotent intra day satellite load - 2 cycles - second cycle is entirely duplicated, composite PK
    Given the SATELLITE_COMP table does not exist
    And the RAW_STAGE_COMP table contains data
      | CUSTOMER_ID | ORDER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | A        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03     | 2019-05-03 | *      |
      | 1002        | B        | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER_COMP data
    When I load the SATELLITE_COMP sat
    Then the SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK | HASHDIFF                                                  | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | md5('A') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215\|\|A') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03     | 2019-05-03 | *      |
      | md5('1002') | md5('B') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215\|\|B') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
    And I load the SATELLITE_COMP sat
    Then the SATELLITE_COMP table should contain expected data
      | CUSTOMER_PK | ORDER_PK | HASHDIFF                                                  | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | md5('A') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215\|\|A') | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03     | 2019-05-03 | *      |
      | md5('1002') | md5('B') | md5('1995-08-08\|\|1002\|\|BETH\|\|17-214-233-1215\|\|B') | Beth          | 1995-08-08   | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
