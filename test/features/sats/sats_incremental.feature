Feature: [SAT] Sats loaded using Incremental Materialization
#[SAT-IM-04] and [SAT-IM-05] do not pass when tests are run altogether
# Tests from snowflake_sats.feature that should be moved here:
# [SAT-03] Load data into an empty satellite
# [SAT-07] Load data into a populated satellite where all records load
# [SAT-08] Load data into a populated satellite where some records overlap
# [SAT-09] Load data into a populated satellite where all PKs have a changed hashdiff/payload

  @fixture.satellite
  Scenario: [SAT-IM-01] Load data from empty 2nd stage into an non-existent satellite
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE | CUSTOMER_DOB | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-02] Load data into an non-existent satellite - one cycle
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1005        | Ewan          | 17-214-233-1218 | 1953-01-03   | 1993-01-02 | *      |
      | 1006        | Frida         | 17-214-233-1219 | 1968-09-12   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Ewan          | 17-214-233-1218 | 1953-01-03   | md5('1953-01-03\|\|1005\|\|EWAN\|\|17-214-233-1218')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1219 | 1968-09-12   | md5('1968-09-12\|\|1006\|\|FRIDA\|\|17-214-233-1219') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-03] Load data into an non-existent satellite - two cycles
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1005        | Ewan          | 17-214-233-1218 | 1953-01-03   | 1993-01-02 | *      |
      | 1006        | Frida         | 17-214-233-1219 | 1968-09-12   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-03 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1005        | Ewan          | 17-214-233-1218 | 1953-01-03   | 1993-01-03 | *      |
      | 1006        | Frida         | 17-214-233-1219 | 2008-09-12   | 1993-01-03 | *      |
      | 1007        | George        | 17-214-233-1220 | 1991-11-03   | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Ewan          | 17-214-233-1218 | 1953-01-03   | md5('1953-01-03\|\|1005\|\|EWAN\|\|17-214-233-1218')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1219 | 1968-09-12   | md5('1968-09-12\|\|1006\|\|FRIDA\|\|17-214-233-1219')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-03     | 1993-01-03 | *      |
      | md5('1006') | Frida         | 17-214-233-1219 | 2008-09-12   | md5('2008-09-12\|\|1006\|\|FRIDA\|\|17-214-233-1219')  | 1993-01-03     | 1993-01-03 | *      |
      | md5('1007') | George        | 17-214-233-1220 | 1991-11-03   | md5('1991-11-03\|\|1007\|\|GEORGE\|\|17-214-233-1220') | 1993-01-03     | 1993-01-03 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-04] Load data from empty stage into an empty satellite - two cycles
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE | CUSTOMER_DOB | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-05] Load stage data into an empty satellite - one cycle
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-06] Load stage data + empty stage data into an empty satellite - two cycles
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1005        | Jenny         | 17-214-233-1218 | 1991-03-25   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Jenny         | 17-214-233-1218 | 1991-03-25   | md5('1991-03-25\|\|1005\|\|JENNY\|\|17-214-233-1218') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-07] Load empty stage data into an existing satellite - one cycle
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE | CUSTOMER_DOB | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-08] Load stage data into an existing satellite - one cycle
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1005        | Jenny         | 17-214-233-1218 | 1991-03-25   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Jenny         | 17-214-233-1218 | 1991-03-25   | md5('1991-03-25\|\|1005\|\|JENNY\|\|17-214-233-1218') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-09] Load mixed stage data into an existing satellite - two cycles
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1005        | Jenny         | 17-214-233-1218 | 1991-03-25   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | LOAD_DATE  | SOURCE |
      | 1003        | Chaz          | 17-214-233-1216 | 2013-02-04   | 1993-01-03 | *      |
      | 1005        | Jenny         | 17-214-233-1218 | 1991-03-25   | 1993-01-03 | *      |
      | 1006        | Sara          | 17-214-233-1219 | 2000-02-10   | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chaz          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAZ\|\|17-214-233-1216')  | 1993-01-03     | 1993-01-03 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Jenny         | 17-214-233-1218 | 1991-03-25   | md5('1991-03-25\|\|1005\|\|JENNY\|\|17-214-233-1218') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Sara          | 17-214-233-1219 | 2000-02-10   | md5('2000-02-10\|\|1006\|\|SARA\|\|17-214-233-1219')  | 1993-01-03     | 1993-01-03 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-10] Load data into an non-existent satellite with additional columns - one cycle
    Given the SATELLITE_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE_AC sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | TPCH_CUSTOMER  | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | TPCH_CUSTOMER  | 1993-01-02 | *      |
      | 1005        | Ewan          | 17-214-233-1218 | 1953-01-03   | TPCH_CUSTOMER  | 1993-01-02 | *      |
      | 1006        | Frida         | 17-214-233-1219 | 1968-09-12   | TPCH_CUSTOMER  | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE_AC sat
    Then the SATELLITE_AC table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | CUSTOMER_MT_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | TPCH_CUSTOMER  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Ewan          | 17-214-233-1218 | 1953-01-03   | md5('1953-01-03\|\|1005\|\|EWAN\|\|17-214-233-1218')  | TPCH_CUSTOMER  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1219 | 1968-09-12   | md5('1968-09-12\|\|1006\|\|FRIDA\|\|17-214-233-1219') | TPCH_CUSTOMER  | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-IM-11] Load data into an empty satellite - one cycle
    Given the SATELLITE_AC sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 2013-02-04   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 2018-04-13   | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE_AC sat
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1997-04-24   | TPCH_CUSTOMER  | 1993-01-02 | *      |
      | 1002         | Bobby         | 17-214-233-1215 | 2006-04-17   | TPCH_CUSTOMER  | 1993-01-02 | *      |
      | 1005        | Ewan          | 17-214-233-1218 | 1953-01-03   | TPCH_CUSTOMER  | 1993-01-02 | *      |
      | 1006        | Frida         | 17-214-233-1219 | 1968-09-12   | TPCH_CUSTOMER  | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE_AC sat
    Then the SATELLITE_AC table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | CUSTOMER_MT_ID | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | TPCH_CUSTOMER  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | TPCH_CUSTOMER  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Ewan          | 17-214-233-1218 | 1953-01-03   | md5('1953-01-03\|\|1005\|\|EWAN\|\|17-214-233-1218')  | TPCH_CUSTOMER  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1219 | 1968-09-12   | md5('1968-09-12\|\|1006\|\|FRIDA\|\|17-214-233-1219') | TPCH_CUSTOMER  | 1993-01-02     | 1993-01-02 | *      |
