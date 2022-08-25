Feature: [XTS] Extended Record Tracking Satellites

  @fixture.xts
  Scenario: [XTS-01] Load one stage of records into an empty single satellite XTS
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-02] Load one stage of data into a non-existent single satellite XTS
    Given the XTS table does not exist
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-03] Load duplicated data in one stage into a non-existent single satellite XTS
    Given the XTS table does not exist
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-04] Load duplicated data and unique data in one stage into a non-existent single satellite XTS
    Given the XTS table does not exist
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-05] Loads records from a single stage to an XTS linked to two satellites.
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    Given the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-06] Loads from a single stage to an XTS linked to two satellites with repeating records in the first satellite
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1001') | md5('2006-04-17\|\|1001\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-07] Loads data from a single stage to an XTS linked to two satellites with repeating records in the second satellite
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2006-04-17   | 17-214-233-1215 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2006-04-17\|\|1003\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-08] Loads from a single stage to an XTS linked to two satellites with repeating records in both satellites
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1002        | Chad               | Clarke            | 2006-04-17   | 17-214-233-1215 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1002        | Chad               | Clarke            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('CHAD\|\|1002\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2018-04-13\|\|1002\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-09] Loads records from a single stage to an XTS linked to three satellites
    Given I have an empty RAW_STAGE_3SAT raw stage
    And I have an empty STG_CUSTOMER_3SAT primed stage
    And the XTS_3SAT xts is empty
    And the RAW_STAGE_3SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_3SAT data
    When I load the XTS_3SAT xts
    Then the XTS_3SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME        | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER          | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER          | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER          | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER          | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS  | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS  | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS  | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS  | 1993-01-01 | *      |
      | md5('1001') | md5('OXFORD\|\|OXFORDSHIRE\|\|1001')         | SAT_CUSTOMER_LOCATION | 1993-01-01 | *      |
      | md5('1002') | md5('SWINDON\|\|WILTSHIRE\|\|1002')          | SAT_CUSTOMER_LOCATION | 1993-01-01 | *      |
      | md5('1003') | md5('LINCOLN\|\|LINCOLNSHIRE\|\|1003')       | SAT_CUSTOMER_LOCATION | 1993-01-01 | *      |
      | md5('1004') | md5('BRIGHTON\|\|EAST SUSSEX\|\|1004')       | SAT_CUSTOMER_LOCATION | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-10] Loads data from two separate stages into an XTS accepting feeds to a single satellite
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And the RAW_STAGE_CUSTOMER_CRM table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_CRM data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                          | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')  | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-11] Loads from two stages each containing feeds to one satellite with repeats between stages
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And the RAW_STAGE_CUSTOMER_CRM table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_CRM data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                         | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')  | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')    | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES') | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-12] Loads from two stages each containing feeds to one satellite with repeated records in the first stage
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And the RAW_STAGE_CUSTOMER_CRM table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_CRM data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                          | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')  | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-13] Loads from numerous stages each containing feeds to one satellite with repeated records in both stages
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And the RAW_STAGE_CUSTOMER_CRM table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_CRM data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                          | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER') | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-14] Loads from numerous stages each containing feeds to multiple satellites
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And the RAW_STAGE_CUSTOMER_CRM_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_CRM_2SAT data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER')            | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')             | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1006') | md5('2006-04-17\|\|1006\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1007') | md5('2013-02-04\|\|1007\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1008') | md5('2018-04-13\|\|1008\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-15] Null unique identifier values are not loaded into an empty existing XTS
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                      | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')  | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-16] Null unique identifier values are not loaded into a non-existent XTS
    Given the XTS table does not exist
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                      | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')  | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-17] Load record into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-12-31 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-18] Load one stage of records into an empty single satellite XTS with a single additional column
    Given the XTS_AC xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS_AC xts
    Then the XTS_AC table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | TPCH_CUSTOMER  | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-19] Load one stage of records into an empty single satellite XTS with multiple additional columns
    Given the XTS_AC_M xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | CUSTOMER_MT_ID | CUSTOMER_MT_ID_2 | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS_AC_M xts
    Then the XTS_AC_M table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | CUSTOMER_MT_ID | CUSTOMER_MT_ID_2 | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | TPCH_CUSTOMER  | TPCH_CUSTOMER    | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-20] Loads from numerous stages each containing feeds to multiple satellites with additional columns
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT_AC xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | CUSTOMER_MT_ID  | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | TPCH_CUSTOMER_D | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And the RAW_STAGE_CUSTOMER_CRM_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_CRM_2SAT data
    When I load the XTS_2SAT_AC xts
    Then the XTS_2SAT_AC table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | CUSTOMER_MT_ID  | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')                | SAT_CUSTOMER         | TPCH_CUSTOMER   | 1993-01-01 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')                 | SAT_CUSTOMER         | TPCH_CUSTOMER   | 1993-01-01 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER')            | SAT_CUSTOMER         | TPCH_CUSTOMER   | 1993-01-01 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')             | SAT_CUSTOMER         | TPCH_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER_D | 1993-01-01 | *      |
      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER   | 1993-01-01 | *      |
      | md5('1006') | md5('2006-04-17\|\|1006\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER   | 1993-01-01 | *      |
      | md5('1007') | md5('2013-02-04\|\|1007\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER   | 1993-01-01 | *      |
      | md5('1008') | md5('2018-04-13\|\|1008\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER   | 1993-01-01 | *      |
