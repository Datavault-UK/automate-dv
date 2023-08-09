Feature: [SAT-PM-B] Satellites Loaded using Period Materialization for base loads

  @fixture.satellite
  Scenario: [SAT-PM-B-01] Base load of a satellite with one value in rank column loads first rank
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-PM-B-02] Incremental load of a satellite with one value in rank column loads all records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-PM-B-03] Incremental load of a satellite should not load PK NULLs
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | <null>      | Emily         | 2018-04-11   | 17-214-233-1218 | 1993-01-01 | *      |
      |             | Fred          | 2018-06-11   | 17-214-233-1219 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.enable_full_refresh
  @fixture.satellite_cycle
  Scenario: [SAT-PM-B-04] Base load of a satellite using full refresh and start and end dates should only contain first period records
    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1004        | 1992-01-30   | David         | 17-214-233-1217 | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by day with date range: 2019-05-05 to 2019-05-06 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID\|\|17-214-233-1217') | 1992-01-30   | David         | 17-214-233-1217 | 2019-05-05     | 2019-05-05 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-B-05] Base load of a satellite should not load PK NULLs
    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | 1990-02-03   | Albert        | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | 1995-08-07   | Beth          | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | 1990-02-03   | Charley       | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_DOB | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | <null>      | 1992-01-30   | David         | 17-214-233-1299 | 2019-05-05     | 2019-05-05 | *      |
      |             | 1992-01-30   | Emily         | 17-214-233-1299 | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by day with date range: 2019-05-05 to 2019-05-06 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |

  @fixture.enable_full_refresh
  @fixture.satellite_cycle
  Scenario: [SAT-PM-B-06] Base load of a satellite using full refresh and only start date should only contain first period records
    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1004        | David         | 1992-01-30   | 17-214-233-1217 | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period starting from 2019-05-05 by day into the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID\|\|17-214-233-1217') | David         | 1992-01-30   | 17-214-233-1217 | 2019-05-05     | 2019-05-05 | *      |

  @fixture.satellite
  Scenario: [SAT-PM-B-07] Incremental load of a new satellite using insert by period and additional columns
    Given the SATELLITE_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | A              | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | B              | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | C              | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | D              | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE_AC sat by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the SATELLITE_AC table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_MT_ID | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | A              | 1997-04-24   | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | B              | 2006-04-17   | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | C              | 2013-02-04   | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | D              | 2018-04-13   | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-PM-B-08] Incremental load of empty satellite using insert by period and additional columns
    Given the SATELLITE_AC sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE_AC sat by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the SATELLITE_AC table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_MT_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-PM-B-09] Incremental load of empty satellite using insert by period
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by day with date range: 1993-01-01 to 1993-01-03 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |
