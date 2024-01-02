Feature: [SAT-GR] Implementing ghost records

  @fixture.satellite
  @fixture.enable_ghost_records
  Scenario: [SAT-GR-01] Load data and ghost record into non-existent satellite
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  Scenario: [SAT-GR-02] Load data and ghost record into an empty satellite
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  Scenario: [SAT-GR-03] Load data and ghost record into satellite already populated with a ghost record
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1006')                      | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1005')                      | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1006')                      | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  Scenario: [SAT-GR-04] Load data and ghost record into already populated satellite
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
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1005')                      | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1006')                      | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  Scenario: [SAT-GR-05] Load data into a non-existent satellite with ghost records not enabled
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha
  Scenario: [SAT-GR-SHA-06] Load data and ghost record into non-existent satellite with SHA hash
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                                                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                         | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000000000000000000000000000 | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha('1001')                                                      | Alice         | 17-214-233-1214 | 1997-04-24   | sha('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')            | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1002')                                                      | Bob           | 17-214-233-1215 | 2006-04-17   | sha('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')              | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1003')                                                      | Chad          | 17-214-233-1216 | 2013-02-04   | sha('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')             | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1004')                                                      | Dom           | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')              | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha
  Scenario: [SAT-GR-SHA-07] Load data and ghost record into an empty satellite with SHA hash
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                                                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                         | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000000000000000000000000000 | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha('1001')                                                      | Alice         | 17-214-233-1214 | 1997-04-24   | sha('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')            | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1002')                                                      | Bob           | 17-214-233-1215 | 2006-04-17   | sha('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')              | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1003')                                                      | Chad          | 17-214-233-1216 | 2013-02-04   | sha('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')             | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1004')                                                      | Dom           | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')              | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha
  Scenario: [SAT-GR-SHA-08] Load data and ghost record into satellite already populated with a ghost record with SHA hash
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK                                                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                         | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000000000000000000000000000 | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha('1004')                                                      | Dom           | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')              | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1006')                                                      | Frida         | 17-214-233-1214 | 2018-04-13   | sha('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214')            | 1993-01-01     | 1993-01-01 | *                  |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                                                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                         | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000000000000000000000000000 | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha('1001')                                                      | Alice         | 17-214-233-1214 | 1997-04-24   | sha('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')            | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1002')                                                      | Bob           | 17-214-233-1215 | 2006-04-17   | sha('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')              | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1003')                                                      | Chad          | 17-214-233-1216 | 2013-02-04   | sha('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')             | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1004')                                                      | Dom           | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')              | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1005')                                                      | Eric          | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')             | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1006')                                                      | Frida         | 17-214-233-1214 | 2018-04-13   | sha('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214')            | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha
  Scenario: [SAT-GR-SHA-09] Load data and ghost record into already populated satellite with SHA hash
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | sha('1006') | Frida         | 17-214-233-1214 | 2018-04-13   | sha('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                                                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                                         | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000000000000000000000000000 | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha('1001')                                                      | Alice         | 17-214-233-1214 | 1997-04-24   | sha('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')            | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1002')                                                      | Bob           | 17-214-233-1215 | 2006-04-17   | sha('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')              | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1003')                                                      | Chad          | 17-214-233-1216 | 2013-02-04   | sha('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')             | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1004')                                                      | Dom           | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')              | 1993-01-01     | 1993-01-01 | *                  |
      | sha('1005')                                                      | Eric          | 17-214-233-1217 | 2018-04-13   | sha('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')             | 1993-01-02     | 1993-01-02 | *                  |
      | sha('1006')                                                      | Frida         | 17-214-233-1214 | 2018-04-13   | sha('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214')            | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_sha
  Scenario: [SAT-GR-SHA-10] Load data into a non-existent satellite with ghost records not enabled with SHA hash
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha('1001') | sha('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | sha('1002') | sha('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | sha('1003') | sha('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | sha('1004') | sha('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.system_record_value
  Scenario: [SAT-GR-11] Load data and ghost record into non-existent satellite with different source system
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE       |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | OTHER_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *            |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *            |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *            |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *            |

  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.system_record_value
  Scenario: [SAT-GR-12] Load data and ghost record into satellite already populated with a ghost record and change of source system
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1006')                      | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1005')                      | Eric          | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *                  |
      | md5('1006')                      | Frida         | 17-214-233-1214 | 2018-04-13   | md5('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  Scenario: [SAT-GR-13] Load data and ghost record into non-existent satellite with Hashdiff alias
    Given the SATELLITE_HD_ALIAS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE_HD_ALIAS sat
    Then the SATELLITE_HD_ALIAS table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | CUSTOMER_HASHDIFF                                     | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *                  |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |

  @fixture.satellite
  @fixture.enable_ghost_records
  Scenario: [SAT-GR-14] Load data and ghost record into non-existent satellite with TIMESTAMP_TZ date types
    Given the SATELLITE_TZ table does not exist
    And the RAW_STAGE_TZ table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 00:00:00 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 00:00:00 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 00:00:00 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 00:00:00 | *      |
    And I stage the STG_CUSTOMER_TZ data
    When I load the SATELLITE_TZ sat
    Then the SATELLITE_TZ table should contain expected data
      | CUSTOMER_PK                      | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                              | EFFECTIVE_FROM      | LOAD_DATE           | SOURCE             |
      | 00000000000000000000000000000000 | <null>        | <null>          | <null>       | 00000000000000000000000000000000                      | 1900-01-01 00:00:00 | 1900-01-01 00:00:00 | AUTOMATE_DV_SYSTEM |
      | md5('1001')                      | Alice         | 17-214-233-1214 | 1997-04-24   | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01 00:00:00 | 1993-01-01 00:00:00 | *                  |
      | md5('1002')                      | Bob           | 17-214-233-1215 | 2006-04-17   | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01 00:00:00 | 1993-01-01 00:00:00 | *                  |
      | md5('1003')                      | Chad          | 17-214-233-1216 | 2013-02-04   | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01 00:00:00 | 1993-01-01 00:00:00 | *                  |
      | md5('1004')                      | Dom           | 17-214-233-1217 | 2018-04-13   | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01 00:00:00 | 1993-01-01 00:00:00 | *                  |

    @not_postgres
  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-15] Load data and ghost record into non-existent satellite with SHA1 hash
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |

  @not_postgres
  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-16] Load data and ghost record into an empty satellite with SHA1 hash
    Given the SATELLITE sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |

  @not_postgres
  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-17] Load data and ghost record into satellite already populated with a ghost record with SHA1 hash
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1006')                             | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1005')                             | Eric          | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1006')                             | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |

  @not_postgres
  @fixture.satellite
  @fixture.enable_ghost_records
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-18] Load data and ghost record into already populated satellite with SHA1 hash
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK  | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1004') | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1006') | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 2018-04-13   | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK                              | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | HASHDIFF                                               | EFFECTIVE_FROM | LOAD_DATE  | SOURCE             |
      | 0000000000000000000000000000000000000000 | <null>        | <null>          | <null>       | 0000000000000000000000000000000000000000               | 1900-01-01     | 1900-01-01 | AUTOMATE_DV_SYSTEM |
      | sha1('1001')                             | Alice         | 17-214-233-1214 | 1997-04-24   | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1002')                             | Bob           | 17-214-233-1215 | 2006-04-17   | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1003')                             | Chad          | 17-214-233-1216 | 2013-02-04   | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1004')                             | Dom           | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *                  |
      | sha1('1005')                             | Eric          | 17-214-233-1217 | 2018-04-13   | sha1('2018-04-13\|\|1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *                  |
      | sha1('1006')                             | Frida         | 17-214-233-1214 | 2018-04-13   | sha1('2018-04-13\|\|1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *                  |

  @not_postgres
  @fixture.satellite
  @fixture.enable_sha1
  Scenario: [SAT-GR-SHA-19] Load data into a non-existent satellite with ghost records not enabled with SHA1 hash
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK  | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha1('1001') | sha1('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1002') | sha1('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1003') | sha1('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 1993-01-01     | 1993-01-01 | *      |
      | sha1('1004') | sha1('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 1993-01-01     | 1993-01-01 | *      |

