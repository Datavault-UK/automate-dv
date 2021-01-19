@fixture.set_workdir
Feature: XTS

  @fixture.xts
  Scenario: [BASE-LOAD] Load one stage of records into an empty single satellite XTS
    Given the XTS xts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load one stage of data into a non-existent single satellite XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load duplicated data in one stage into a non-existent single satellite XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load duplicated data in one stage into a non-existent single satellite XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Load multiple subsequent stages into a single stage XTS with no timeline change
    Given the XTS xts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-03 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads records from a single stage to an XTS linked to two satellites.
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    Given the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Charlie         | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to an XTS linked to two satellites with repeating records in the first satellite
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Charlie         | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1001') | md5('2006-04-17\|\|1001\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads data from a single stage to an XTS linked to two satellites with repeating records in the second satellite
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1002        | Chad            | 2013-02-04     | 17-214-233-1216  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2013-02-04\|\|1002\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to an XTS linked to two satellites with repeating records in the both satellites
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1002        | Chad            | 2013-02-04     | 17-214-233-1216  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1002        | Chad            | 2013-02-04     | 17-214-233-1216  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2013-02-04\|\|1002\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2018-04-13\|\|1002\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads records from a single stage to an XTS with two satellites with duplicate payloads
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Alice           | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Bob             | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Chad            | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | Dom             | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |


  @fixture.xts
  Scenario: [BASE-LOAD] Loads records from a single stage to an XTS linked to three satellites
    Given I will have a RAW_STAGE_3SAT raw stage and I have a STG_CUSTOMER_3SAT processed stage
    And the XTS_3SAT xts is empty
    And the RAW_STAGE_3SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | CUSTOMER_NAME_3 | CUSTOMER_DOB_3 | CUSTOMER_PHONE_3 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | Anne            | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | Barny           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Charlie         | 2013-02-04     | 17-214-233-1216  | Cisco           | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | Donald          | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_3SAT stage
    When I load the XTS_3SAT xts
    Then the XTS_3SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANNE\|\|17-214-233-1214')     | SAT_CUSTOMER_OTHER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BARNY\|\|17-214-233-1215')    | SAT_CUSTOMER_OTHER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CISCO\|\|17-214-233-1216')    | SAT_CUSTOMER_OTHER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DONALD\|\|17-214-233-1217')   | SAT_CUSTOMER_OTHER   | 1993-01-01 | *      |


  @fixture.xts
  Scenario: [BASE-LOAD] Loads data from two simultaneous stages in an XTS accepting feeds to a single satellite
    Given the XTS xts is empty
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_1 stage
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1005        | Edward        | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2 stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1005') | md5('2018-04-13\|\|1005\|\|EDWARD\|\|17-214-233-1217')   | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from two stages each containing feeds to one satellite with repeats between stages
    Given the XTS xts is empty
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_1 stage
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2 stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217') | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from two stages each containing feeds to one satellite with repeated records in the first stage
    Given the XTS xts is empty
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_1 stage
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2 stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from numerous stages each containing feeds to one satellite with repeated records in both stages
    Given the XTS xts is empty
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_1 stage
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2 stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216') | SAT_CUSTOMER   | 1993-01-01 | *      |


  @fixture.xts
  Scenario: [BASE-LOAD] Loads from numerous stages each containing feeds to multiple satellites
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Alice           | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Bob             | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Chad            | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | Dom             | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT_1 stage
    And the RAW_STAGE_2SAT_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle        | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Billy           | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Charlie         | 2013-02-04     | 17-214-233-1216  | Charlie         | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | David           | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT_2 stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Null unique identifier values are not loaded into an empty existing XTS
    Given the XTS xts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                             | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')  | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Null unique identifier values are not loaded into a non-existent XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                             | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')  | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Load record into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Load duplicated data into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Subsequent loads with no timeline change into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                            | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213') | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1000        | Zak           | 1992-12-25   | 17-214-233-1213 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1000        | Zak           | 1992-12-25   | 17-214-233-1213 | 1993-01-02 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-02 | *      |
    And I create the STG_CUSTOMER stage
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-03 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-03 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213')   | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213')   | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-03 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Loads from a single stage to multiple satellites and a pre-populated xts
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1992-12-31 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-27     | 17-214-233-1215  | 1992-12-31 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    And I load the XTS_2SAT xts
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Charlie         | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-27\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Loads from numerous stages each containing feeds to one satellite and a pre-populated xts
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_1 stage
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2 stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Loads from numerous stages each containing feeds to multiple satellites and a pre-populated xts
    Given I will have a RAW_STAGE_2SAT raw stage and I have a STG_CUSTOMER_2SAT processed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Billy           | 2006-04-17     | 17-214-233-1215  | 1992-12-31 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    And I load the XTS_2SAT xts
    And the RAW_STAGE_2SAT_1 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Alice           | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Bob             | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Chad            | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | Dom             | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT_1 stage
    And the RAW_STAGE_2SAT_2 table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle        | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Billy           | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Charlie         | 2013-02-04     | 17-214-233-1216  | Charlie         | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | David           | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT_2 stage
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1992-12-31 | *      |
      | md5('1001') | md5('2006-04-17\|\|1001\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Null unique identifier values are not loaded into an pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_CUSTOMER   | 1993-01-01 | *      |