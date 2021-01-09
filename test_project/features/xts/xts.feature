@fixture.set_workdir
Feature: XTS Customer

  # Single stage, single satellite
  @fixture.xts
  Scenario: [BASE-LOAD] Load records into an empty XTS
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
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load data into a non-existent XTS
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
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load duplicated data into a non-existent XTS
    Given the XTS table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Load duplicated data into a non-existent XTS
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
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

#    Mulitple stage single satellite
  @fixture.xts
  Scenario: [BASE-LOAD] Subsequent loads with no timeline change
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
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-02 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-02 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-03 | *      |

#    Single stage with two satellites
  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to 2 satellites
    Given the XTS xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1 | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214  | Anabelle        | 1997-04-24     | 17-214-233-1214  | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215  | Billy           | 2006-04-17     | 17-214-233-1215  | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216  | Charlie         | 2013-02-04     | 17-214-233-1216  | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217  | David           | 2018-04-13     | 17-214-233-1217  | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('1997-04-17\|\|1002\|\|BOB\|\|17-214-233-12145')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to 2 satellites with repeating records in the first satellite
    Given the XTS xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Charlie         | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1001') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to 2 satellites with repeating records in the second satellite
    Given the XTS xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('1997-04-17\|\|1002\|\|BOB\|\|17-214-233-12145')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to 2 satellites with repeating records in the both satellites
    Given the XTS xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1004        | Chad            | 2013-02-04     | 17-214-233-1216   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('1997-04-17\|\|1002\|\|BOB\|\|17-214-233-12145')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to 2 satellites with duplicate payloads
    Given the XTS xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Alice           | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Bob             | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Chad            | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | Dom             | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('1997-04-17\|\|1002\|\|BOB\|\|17-214-233-12145')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('1997-04-17\|\|1002\|\|BOB\|\|17-214-233-12145')     | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |


#    Single stage with many satellites
  @fixture.xts
  Scenario: [BASE-LOAD] Loads from a single stage to multiple satellites
    Given the XTS xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | CUSTOMER_NAME_3 | CUSTOMER_DOB_3 | CUSTOMER_PHONE_3  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | Anne            | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Billy           | 2006-04-17     | 17-214-233-1215   | Barny           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Charlie         | 2013-02-04     | 17-214-233-1216   | Cisco           | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | Donald          | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANNE\|\|17-214-233-1214')     | SAT_SAP_CUSTOMER3 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BARNY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER3 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CISCO\|\|17-214-233-1216')    | SAT_SAP_CUSTOMER3 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DONALD\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER3 | 1993-01-01  | *      |

#    Many stages, one satellite
  @fixture.xts
  Scenario: [BASE-LOAD] Loads from numerous stages each containing feeds to one satellite
    Given the XTS xts is empty
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_FIRST stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_SECOND stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from two stages each containing feeds to one satellite with repeats between stages
    Given the XTS xts is empty
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_FIRST stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_SECOND stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from two stages each containing feeds to one satellite with repeated records in the first stage
    Given the XTS xts is empty
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  |  LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 |  1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 |  1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 |  1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 |  1993-01-01 | *      |
    And I create the STG_CUSTOMER_FIRST stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  |  LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 |  1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 |  1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 |  1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 |  1993-01-01 | *      |
    And I create the STG_CUSTOMER_SECOND stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [BASE-LOAD] Loads from numerous stages each containing feeds to one satellite with repeated records in both stages
    Given the XTS xts is empty
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_FIRST stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  |  LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 |  1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 |  1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 |  1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 |  1993-01-01 | *      |
    And I create the STG_CUSTOMER_SECOND stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |


  @fixture.disable_union
  @fixture.xts
  Scenario: [BASE-LOAD] Loads from numerous stages each containing feeds to multiple satellites
    Given the XTS xts is empty
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Alice           | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Bob             | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Chad            | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | Dom             | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle        | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Billy           | 2006-04-17     | 17-214-233-1215   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Charlie         | 2013-02-04     | 17-214-233-1216   | Charlie         | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | David           | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |

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
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

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
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

### Pre-populated xts satellite tests: ###

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Load record into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-12-31  | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-12-31  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Load duplicated data into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Subsequent loads with no timeline change into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213')   | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
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
      | CUSTOMER_PK | HASHDIFF                                              | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213')   | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1000') | md5('1992-12-25\|\|1000\|\|ZAK\|\|17-214-233-1213')   | SAT_SAP_CUSTOMER | 1993-01-02  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-02  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-02  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-03  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-03  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-03  | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Loads from a single stage to multiple satellites and a pre-populated xts
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1992-12-31  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1992-12-31  | *      |
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Charlie         | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_2SAT stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1992-12-31  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1992-12-31  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER2 | 1993-01-01  | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Loads from numerous stages each containing feeds to one satellite and a pre-populated xts
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME   | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_FIRST stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle      | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Billy         | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Charlie       | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | David         | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER_SECOND stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME   | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER | 1993-01-01 | *      |

  @fixture.disable_union
  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Loads from numerous stages each containing feeds to multiple satellites and a pre-populated xts
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1992-12-31  | *      |
    And the FIRST_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Alice           | 1997-04-24     | 17-214-233-1214   | Alice           | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Bob             | 2006-04-17     | 17-214-233-1215   | Bob             | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Chad            | 2013-02-04     | 17-214-233-1216   | Chad            | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | Dom             | 2018-04-13     | 17-214-233-1217   | Dom             | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    And the SECOND_RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME_1 | CUSTOMER_DOB_1 | CUSTOMER_PHONE_1  | CUSTOMER_NAME_2 | CUSTOMER_DOB_2 | CUSTOMER_PHONE_2  | LOAD_DATE  | SOURCE |
      | 1001        | Anabelle        | 1997-04-24     | 17-214-233-1214   | Anabelle        | 1997-04-24     | 17-214-233-1214   | 1993-01-01 | *      |
      | 1002        | Billy           | 2006-04-17     | 17-214-233-1215   | Billy           | 2006-04-17     | 17-214-233-1215   | 1993-01-01 | *      |
      | 1003        | Charlie         | 2013-02-04     | 17-214-233-1216   | Charlie         | 2013-02-04     | 17-214-233-1216   | 1993-01-01 | *      |
      | 1004        | David           | 2018-04-13     | 17-214-233-1217   | David           | 2018-04-13     | 17-214-233-1217   | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                 | SATELLITE_NAME    | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER2 | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ANABELLE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BILLY\|\|17-214-233-1215')    | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHARLIE\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DAVID\|\|17-214-233-1217')    | SAT_SAP_CUSTOMER1 | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214')    | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')      | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')     | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')      | SAT_SAP_CUSTOMER2 | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [INCREMENTAL-LOAD] Null unique identifier values are not loaded into an pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                                              | SAT_NAME         | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-12-31  | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I create the STG_CUSTOMER stage
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                              | SAT_NAME         | LOAD_DATE   | SOURCE |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|ALICE\|\|17-214-233-1214') | SAT_SAP_CUSTOMER | 1992-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-12-31  | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|BOB\|\|17-214-233-1215')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|CHAD\|\|17-214-233-1216')  | SAT_SAP_CUSTOMER | 1993-01-01  | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|DOM\|\|17-214-233-1217')   | SAT_SAP_CUSTOMER | 1993-01-01  | *      |