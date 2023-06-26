Feature: [WTL] Water Level

  @fixture.satellite
  Scenario: [WTL-01] Load a non existent satellite, using a water level earlier than all stage records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 2018-06-02 00:00:00.000 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 2018-06-03 00:00:00.000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 2018-06-04 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And the WATERLEVEL table contains data
      | TABLE_NAME | WATER_LEVEL                |
      | SATELLITE  | 2018-05-30 00:00:00.000000 |
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                           | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('2018-06-01 00:00:00.000\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | md5('2018-06-02 00:00:00.000\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | md5('2018-06-03 00:00:00.000\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 2018-06-03 00:00:00.000 | 2018-06-03 00:00:00.000 | *      |
      | md5('1004') | md5('2018-06-04 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 2018-06-04 00:00:00.000 | 2018-06-04 00:00:00.000 | *      |

  @fixture.satellite
  Scenario: [WTL-01] Load a non existent satellite, using a water level earlier than all stage records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 2018-06-02 00:00:00.000 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 2018-06-03 00:00:00.000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 2018-06-04 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And the AS_OF_DATE table contains data
      | AS_OF_DATE                 |
      | 2018-05-30 00:00:00.000000 |
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                           | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('2018-06-01 00:00:00.000\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | md5('2018-06-02 00:00:00.000\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | md5('2018-06-03 00:00:00.000\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 2018-06-03 00:00:00.000 | 2018-06-03 00:00:00.000 | *      |
      | md5('1004') | md5('2018-06-04 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 2018-06-04 00:00:00.000 | 2018-06-04 00:00:00.000 | *      |

  @fixture.satellite
  Scenario: [WTL-02] Load a non existent satellite, using a water level earlier all but one stage record
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 2018-06-02 00:00:00.000 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 2018-06-03 00:00:00.000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 2018-06-04 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And the AS_OF_DATE table contains data
      | AS_OF_DATE                 |
      | 2018-06-01 00:00:00.000000 |
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                          | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1002') | md5('2018-06-02 00:00:00.000\|\|1002\|\|BOB\|\|17-214-233-1215')  | Bob           | 17-214-233-1215 | 2006-04-17   | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | md5('2018-06-03 00:00:00.000\|\|1003\|\|CHAD\|\|17-214-233-1216') | Chad          | 17-214-233-1216 | 2013-02-04   | 2018-06-03 00:00:00.000 | 2018-06-03 00:00:00.000 | *      |
      | md5('1004') | md5('2018-06-04 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')  | Dom           | 17-214-233-1217 | 2018-04-13   | 2018-06-04 00:00:00.000 | 2018-06-04 00:00:00.000 | *      |

  @fixture.satellite
  Scenario: [WTL-03] Load a non existent satellite, set after all stage records
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 2018-06-02 00:00:00.000 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 2018-06-03 00:00:00.000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 2018-06-04 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    And the AS_OF_DATE table contains data
      | AS_OF_DATE                 |
      | 2018-06-04 00:00:00.000000 |
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF | CUSTOMER_NAME | CUSTOMER_PHONE | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATETIME | SOURCE |

  @fixture.satellite
  Scenario: [WTL-04] Load an already populated satellite using a water level, set from previous load
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                           | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('2018-06-01 00:00:00.000\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | md5('2018-06-02 00:00:00.000\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | md5('2018-06-03 00:00:00.000\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 2018-06-03 00:00:00.000 | 2018-06-03 00:00:00.000 | *      |
      | md5('1004') | md5('2018-06-04 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 2018-06-04 00:00:00.000 | 2018-06-04 00:00:00.000 | *      |
    And the AS_OF_DATE table contains data
      | AS_OF_DATE                 |
      | 2018-06-04 00:00:00.000000 |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1005        | ARAN          | 1998-04-24   | 18-214-233-1214 | 2018-06-05 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                           | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('2018-06-01 00:00:00.000\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | md5('2018-06-02 00:00:00.000\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | md5('2018-06-03 00:00:00.000\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 2018-06-03 00:00:00.000 | 2018-06-03 00:00:00.000 | *      |
      | md5('1004') | md5('2018-06-04 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 2018-06-04 00:00:00.000 | 2018-06-04 00:00:00.000 | *      |
      | md5('1005') | md5('2018-06-05 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')   | Aran          | 18-214-233-1214 | 1998-04-24   | 2018-06-05 00:00:00.000 | 2018-06-05 00:00:00.000 | *      |

  @fixture.satellite
  Scenario: [WTL-05] Load an already populated satellite using a water level with static stage, set from previous load
    Given the SATELLITE sat is already populated with data
      | CUSTOMER_PK | HASHDIFF                                                           | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('2018-06-01 00:00:00.000\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | md5('2018-06-02 00:00:00.000\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | md5('2018-06-03 00:00:00.000\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 2018-06-03 00:00:00.000 | 2018-06-03 00:00:00.000 | *      |
      | md5('1004') | md5('2018-06-04 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 2018-06-04 00:00:00.000 | 2018-06-04 00:00:00.000 | *      |
    And the AS_OF_DATE table contains data
      | AS_OF_DATE                 |
      | 2018-06-04 00:00:00.000000 |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATETIME           | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 2018-06-01 00:00:00.000 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 2018-06-02 00:00:00.000 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 2018-06-03 00:00:00.000 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 2018-06-04 00:00:00.000 | *      |
    And I stage the STG_CUSTOMER data
    When I load the SATELLITE sat
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                           | CUSTOMER_NAME | CUSTOMER_PHONE  | CUSTOMER_DOB | EFFECTIVE_FROM          | LOAD_DATETIME           | SOURCE |
      | md5('1001') | md5('2018-06-01 00:00:00.000\|\|1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1997-04-24   | 2018-06-01 00:00:00.000 | 2018-06-01 00:00:00.000 | *      |
      | md5('1002') | md5('2018-06-02 00:00:00.000\|\|1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 2006-04-17   | 2018-06-02 00:00:00.000 | 2018-06-02 00:00:00.000 | *      |
      | md5('1003') | md5('2018-06-03 00:00:00.000\|\|1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 2013-02-04   | 2018-06-03 00:00:00.000 | 2018-06-03 00:00:00.000 | *      |
      | md5('1004') | md5('2018-06-04 00:00:00.000\|\|1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 2018-04-13   | 2018-06-04 00:00:00.000 | 2018-06-04 00:00:00.000 | *      |
