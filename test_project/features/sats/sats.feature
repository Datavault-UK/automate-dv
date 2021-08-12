@fixture.set_workdir
Feature: Satellites

  @fixture.satellite
  Scenario: [BASE-LOAD] Load data into a non-existent satellite
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [BASE-LOAD] Load duplicated data into a non-existent satellite
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [BASE-LOAD-EMPTY] Load data into an empty satellite
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [BASE-LOAD-EMPTY-NULLS] Load data into an empty satellite where payload/hashdiff data is all null and PKs are NULL
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | <null>      | <null>        | <null>       | <null>          | 1993-01-01 | *      |
      |             | <null>        | <null>       | <null>          | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  # recently changed (Added more combinations of null columns)
  @fixture.satellite
  Scenario: [BASE-LOAD-EMPTY] Load data into an empty satellite where payload/hashdiff data is partially null and some PKs are NULL
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | <null>      | <null>        | <null>       | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | <null>        | 1988-02-11   | <null>          | 1993-01-01 | *      |
      | <null>      | Frida         | <null>       | <null>          | 1993-01-01 | *      |
      | 1005        | <null>        | <null>       | <null>          | 1993-01-01 | *      |
      | <null>      | <null>        | 1988-02-11   | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | Frida         | <null>       | 17-214-233-1218 | 1993-01-01 | *      |
      | 1006        | <null>        | <null>       | 17-214-233-1218 | 1993-01-01 | *      |
      | <null>      | Frida         | 1988-02-11   | <null>          | 1993-01-01 | *      |
      | 1007        | <null>        | 1988-02-11   | <null>          | 1993-01-01 | *      |
      | 1008        | Frida         | <null>       | <null>          | 1993-01-01 | *      |
      | 1009        | Albert        | 2001-01-01   | <null>          | 1993-01-01 | *      |
      | 1010        | Ben           | <null>       | 17-214-233-1219 | 1993-01-01 | *      |
      | 1011        | <null>        | 1977-07-07   | 17-214-233-1221 | 1993-01-01 | *      |
      | <null>      | Charlie       | 1988-08-08   | 17-214-233-1222 | 1993-01-01 | *      |

    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | <null>        | <null>          | <null>       | md5('^^\|\|1005\|\|^^\|\|^^')                         | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | <null>        | 17-214-233-1218 | <null>       | md5('^^\|\|1006\|\|^^\|\|17-214-233-1218')            | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | <null>        | <null>          | 1988-02-11   | md5('1988-02-11\|\|1007\|\|^^\|\|^^')                 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1008') | Frida         | <null>          | <null>       | md5('^^\|\|1008\|\|FRIDA\|\|^^')                      | 1993-01-01     | 1993-01-01 | *      |
      | md5('1009') | Albert        | <null>          | 2001-01-01   | md5('2001-01-01\|\|1009\|\|ALBERT\|\|^^')             | 1993-01-01     | 1993-01-01 | *      |
      | md5('1010') | Ben           | 17-214-233-1219 | <null>       | md5('^^\|\|1010\|\|BEN\|\|17-214-233-1219')           | 1993-01-01     | 1993-01-01 | *      |
      | md5('1011') | <null>        | 17-214-233-1221 | 1977-07-07   | md5('1977-07-07\|\|1011\|\|^^\|\|17-214-233-1221')    | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [BASE-LOAD-EMPTY] Load duplicated data into an empty satellite
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated satellite where all records load
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated satellite where some records overlap
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |

  # recently added
  @fixture.satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated satellite where all PKs have a changed hashdiff/payload
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Frida         | 17-214-233-1218 | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|17-214-233-1218')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | George        | 17-214-233-1219 | 1998-04-13   | md5('1998-04-13\|\|1006\|\|GEORGE\|\|17-214-233-1219') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | Harry         | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|HARRY\|\|17-214-233-1220')  | 1993-01-01     | 1993-01-01 | *      |

    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alicia        | 1997-04-25   | 17-214-233-1314 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-18   | 17-214-233-1315 | 1993-01-02 | *      |
      | 1003        | Chaz          | 2013-02-05   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1004        | Don           | 2018-04-13   | 17-214-233-1317 | 1993-01-02 | *      |
      | 1005        | Frida         | 2008-04-13   | 17-214-233-1318 | 1993-01-02 | *      |
      | 1006        | George        | 1998-04-14   | 17-214-233-1219 | 1993-01-02 | *      |
      | 1007        | Hary          | 1988-04-13   | 17-214-233-1220 | 1993-01-02 | *      |

    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Frida         | 17-214-233-1218 | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|17-214-233-1218')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | George        | 17-214-233-1219 | 1998-04-13   | md5('1998-04-13\|\|1006\|\|GEORGE\|\|17-214-233-1219') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | Harry         | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|HARRY\|\|17-214-233-1220')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Alicia        | 17-214-233-1314 | 1997-04-25   | md5('1997-04-25\|\|1001\|\|ALICIA\|\|17-214-233-1314') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1315 | 2006-04-18   | md5('2006-04-18\|\|1002\|\|BOB\|\|17-214-233-1315')    | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chaz          | 17-214-233-1216 | 2013-02-05   | md5('2013-02-05\|\|1003\|\|CHAZ\|\|17-214-233-1216')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Don           | 17-214-233-1317 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DON\|\|17-214-233-1317')    | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Frida         | 17-214-233-1318 | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|17-214-233-1318')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | George        | 17-214-233-1219 | 1998-04-14   | md5('1998-04-14\|\|1006\|\|GEORGE\|\|17-214-233-1219') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1007') | Hary          | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|HARY\|\|17-214-233-1220')   | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [INCREMENTAL-LOAD-NULLS] Load data into a populated satellite where payload/hashdiff data is all null and PKs are NULL
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | <null>       | <null>         | 1993-01-02 | *      |
      |             | <null>        | <null>       | <null>         | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |

  # recently created
  @fixture.satellite
  Scenario: [INCREMENTAL-LOAD-NULLS] Load data into a populated satellite where hashdiff/payload data is partially null - existent PKs
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Frida         | 17-214-233-1218 | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|17-214-233-1218')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | George        | 17-214-233-1219 | 1998-04-13   | md5('1998-04-13\|\|1006\|\|GEORGE\|\|17-214-233-1219') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | Harry         | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|HARRY\|\|17-214-233-1220')  | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | <null>       | 17-214-233-1218 | 1993-01-02 | *      |
      | <null>      | <null>        | 1988-02-11   | <null>          | 1993-01-02 | *      |
      | <null>      | Frida         | <null>       | <null>          | 1993-01-02 | *      |
      | 1001        | <null>        | <null>       | <null>          | 1993-01-02 | *      |
      | <null>      | <null>        | 1988-02-11   | 17-214-233-1218 | 1993-01-02 | *      |
      | <null>      | Frida         | <null>       | 17-214-233-1218 | 1993-01-02 | *      |
      | 1002        | <null>        | <null>       | 17-214-233-1215 | 1993-01-02 | *      |
      | <null>      | Frida         | 1988-02-11   | <null>          | 1993-01-02 | *      |
      | 1003        | <null>        | 2013-02-04   | <null>          | 1993-01-02 | *      |
      | 1004        | Dom           | <null>       | <null>          | 1993-01-02 | *      |
      | 1005        | Frida         | 2008-04-13   | <null>          | 1993-01-02 | *      |
      | 1006        | George        | <null>       | 17-214-233-1219 | 1993-01-02 | *      |
      | 1007        | <null>        | 1988-04-13   | 17-214-233-1220 | 1993-01-02 | *      |
      | <null>      | Charlie       | 1988-08-08   | 17-214-233-1222 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Frida         | 17-214-233-1218 | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|17-214-233-1218')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | George        | 17-214-233-1219 | 1998-04-13   | md5('1998-04-13\|\|1006\|\|GEORGE\|\|17-214-233-1219') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | Harry         | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|HARRY\|\|17-214-233-1220')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | <null>        | <null>          | <null>       | md5('^^\|\|1001\|\|^^\|\|^^')                          | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | <null>        | 17-214-233-1215 | <null>       | md5('^^\|\|1002\|\|^^\|\|17-214-233-1215')             | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | <null>        | <null>          | 2013-02-04   | md5('2013-02-04\|\|1003\|\|^^\|\|^^')                  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | <null>          | <null>       | md5('^^\|\|1004\|\|DOM\|\|^^')                         | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Frida         | <null>          | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|^^')               | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | George        | 17-214-233-1219 | <null>       | md5('^^\|\|1006\|\|GEORGE\|\|17-214-233-1219')         | 1993-01-02     | 1993-01-02 | *      |
      | md5('1007') | <null>        | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|^^\|\|17-214-233-1220')     | 1993-01-02     | 1993-01-02 | *      |

  # recently created
  @fixture.satellite
  Scenario: [INCREMENTAL-LOAD-NULLS] Load data into a populated satellite where hashdiff/payload data is partially null - new PKs
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Frida         | 17-214-233-1218 | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|17-214-233-1218')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | George        | 17-214-233-1219 | 1998-04-13   | md5('1998-04-13\|\|1006\|\|GEORGE\|\|17-214-233-1219') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | Harry         | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|HARRY\|\|17-214-233-1220')  | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | <null>       | 17-214-233-1218 | 1993-01-02 | *      |
      | <null>      | <null>        | 1988-02-11   | <null>          | 1993-01-02 | *      |
      | <null>      | Frida         | <null>       | <null>          | 1993-01-02 | *      |
      | 1011        | <null>        | <null>       | <null>          | 1993-01-02 | *      |
      | <null>      | <null>        | 1988-02-11   | 17-214-233-1218 | 1993-01-02 | *      |
      | <null>      | Frida         | <null>       | 17-214-233-1218 | 1993-01-02 | *      |
      | 1012        | <null>        | <null>       | 17-214-233-1215 | 1993-01-02 | *      |
      | <null>      | Frida         | 1988-02-11   | <null>          | 1993-01-02 | *      |
      | 1013        | <null>        | 2013-02-04   | <null>          | 1993-01-02 | *      |
      | 1014        | Dan           | <null>       | <null>          | 1993-01-02 | *      |
      | 1015        | Frida         | 2008-04-13   | <null>          | 1993-01-02 | *      |
      | 1016        | George        | <null>       | 17-214-233-1219 | 1993-01-02 | *      |
      | 1017        | <null>        | 1988-04-13   | 17-214-233-1220 | 1993-01-02 | *      |
      | <null>      | Charlie       | 1988-08-08   | 17-214-233-1222 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Frida         | 17-214-233-1218 | 2008-04-13   | md5('2008-04-13\|\|1005\|\|FRIDA\|\|17-214-233-1218')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | George        | 17-214-233-1219 | 1998-04-13   | md5('1998-04-13\|\|1006\|\|GEORGE\|\|17-214-233-1219') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1007') | Harry         | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1007\|\|HARRY\|\|17-214-233-1220')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1011') | <null>        | <null>          | <null>       | md5('^^\|\|1011\|\|^^\|\|^^')                          | 1993-01-02     | 1993-01-02 | *      |
      | md5('1012') | <null>        | 17-214-233-1215 | <null>       | md5('^^\|\|1012\|\|^^\|\|17-214-233-1215')             | 1993-01-02     | 1993-01-02 | *      |
      | md5('1013') | <null>        | <null>          | 2013-02-04   | md5('2013-02-04\|\|1013\|\|^^\|\|^^')                  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1014') | Dan           | <null>          | <null>       | md5('^^\|\|1014\|\|DAN\|\|^^')                         | 1993-01-02     | 1993-01-02 | *      |
      | md5('1015') | Frida         | <null>          | 2008-04-13   | md5('2008-04-13\|\|1015\|\|FRIDA\|\|^^')               | 1993-01-02     | 1993-01-02 | *      |
      | md5('1016') | George        | 17-214-233-1219 | <null>       | md5('^^\|\|1016\|\|GEORGE\|\|17-214-233-1219')         | 1993-01-02     | 1993-01-02 | *      |
      | md5('1017') | <null>        | 17-214-233-1220 | 1988-04-13   | md5('1988-04-13\|\|1017\|\|^^\|\|17-214-233-1220')     | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [INCREMENTAL-LOAD] Load data into a populated satellite where some records overlap, hashdiff DOES NOT include PK (for G)
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                      | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER_NO_PK_HASHDIFF stage
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                      | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |