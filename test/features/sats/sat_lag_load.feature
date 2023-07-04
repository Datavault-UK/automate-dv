Feature: [SAT] Sats loaded using Incremental Materialization


  @fixture.satellite
  Scenario: [SAT-NLP-01] Incremental load into non existent sat, with first and only record same as latest
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
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-02] Incremental load into non existent sat, with first record same as latest, with a new PK record
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
      | 1005        | Dorothy       | 17-214-233-1218 | 2018-05-14   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Dorothy       | 17-214-233-1218 | 2018-05-14   | md5('2018-05-14\|\|1005\|\|DOROTHY\|\|17-214-233-1218') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-03] Incremental load into non existent sat, with first record same as latest, with a new record with a changed hashdiff
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
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |


  @fixture.satellite
  Scenario: [SAT-NLP-04] Incremental load into non existent sat, with first record same as latest, with new records changed hashdiffs
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
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-05] Incremental load into non existent sat, with first record same as latest, with new records with flip flop hashdiff
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
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-03     | 1993-01-03 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-05] Incremental load into non existent sat, with first record same as latest, with new records with mix of same and changed hashdiffs
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
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-04 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-03     | 1993-01-03 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-06] Incremental load into non existent sat, with first and only record different to latest
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-07] Incremental load into non existent sat, with first record different to latest, with a new PK record
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1005        | Dorothy       | 17-214-233-1218 | 2018-05-14   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')    | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Dorothy       | 17-214-233-1218 | 2018-05-14   | md5('2018-05-14\|\|1005\|\|DOROTHY\|\|17-214-233-1218') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-08] Incremental load into non existent sat, with first record different to latest, with a new record with a changed hashdiff
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |


  @fixture.satellite
  Scenario: [SAT-NLP-09] Incremental load into non existent sat, with first record different to latest, with new records changed hashdiffs
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-10] Incremental load into non existent sat, with first record different to latest, with new records with flip flop hashdiff
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-11] Incremental load into empty sat, with first record different to latest, with new records with mix of same and changed hashdiffs
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-04 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-03     | 1993-01-03 | *      |


  @fixture.satellite
  Scenario: [SAT-NLP-X] Incremental load into empty sat, with first two records same hashdiff, with new records with mix of same and changed hashdiffs
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-03 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-04 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-05 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-06 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-07 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-04     | 1993-01-04 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-06     | 1993-01-06 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-12] Incremental load into empty sat, with first and only record same as latest
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-13] Incremental load into empty sat, with first record same as latest, with a new PK record
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
      | 1005        | Dorothy       | 17-214-233-1218 | 2018-05-14   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Dorothy       | 17-214-233-1218 | 2018-05-14   | md5('2018-05-14\|\|1005\|\|DOROTHY\|\|17-214-233-1218') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-14] Incremental load into empty sat, with first record same as latest, with a new record with a changed hashdiff
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
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |


  @fixture.satellite
  Scenario: [SAT-NLP-15] Incremental load into empty sat, with first record same as latest, with new records changed hashdiffs
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
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-16] Incremental load into empty sat, with first record same as latest, with new records with flip flop hashdiff
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
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-03     | 1993-01-03 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-17] Incremental load into empty sat, with first record same as latest, with new records with mix of same and changed hashdiffs
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
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-04 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-03     | 1993-01-03 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-18] Incremental load into empty sat, with first and only record different to latest
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-19] Incremental load into empty sat, with first record different to latest, with a new PK record
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1005        | Dorothy       | 17-214-233-1218 | 2018-05-14   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')    | 1993-01-02     | 1993-01-02 | *      |
      | md5('1005') | Dorothy       | 17-214-233-1218 | 2018-05-14   | md5('2018-05-14\|\|1005\|\|DOROTHY\|\|17-214-233-1218') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-20] Incremental load into empty sat, with first record different to latest, with a new record with a changed hashdiff
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-21] Incremental load into empty sat, with first record different to latest, with new records with flip flop hashdiff
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *      |

  @fixture.satellite
  Scenario: [SAT-NLP-22] Incremental load into empty sat, with first record different to latest, with new records with mix of same and changed hashdiffs
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
      | 1001        | Ally          | 17-214-233-1214 | 1997-04-24   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-02 | *      |
      | 1002        | Bobby         | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-03 | *      |
      | 1002        | Robert        | 17-214-233-1215 | 2006-04-17   | 1993-01-04 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |
      | md5('1001') | Ally          | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALLY\|\|17-214-233-1214')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bobby         | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOBBY\|\|17-214-233-1215')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Robert        | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|ROBERT\|\|17-214-233-1215') | 1993-01-03     | 1993-01-03 | *      |
    