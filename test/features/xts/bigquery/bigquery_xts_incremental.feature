Feature: [BQ-XTS-INC] Extended Record Tracking Satellites

  @fixture.xts
  Scenario: [BQ-XTS-INC-001] Load multiple subsequent stages into a single stage XTS with no timeline change
    Given the XTS xts is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-03 | *      |

  @fixture.xts
  Scenario: [BQ-XTS-INC-002] Load duplicated data into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BQ-XTS-INC-003] Subsequent loads with no timeline change into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                  | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000') | md5('ZAK\|\|1000\|\|ZON') | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1000        | Zak                | Zon               | 1992-12-25   | 17-214-233-1234 | Cambridgeshire  | Cambridge     | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1000        | Zak                | Zon               | 1992-12-25   | 17-214-233-1234 | Cambridgeshire  | Cambridge     | 1993-01-02 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-03 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000') | md5('ZAK\|\|1000\|\|ZON')       | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1000') | md5('ZAK\|\|1000\|\|ZON')       | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1000') | md5('ZAK\|\|1000\|\|ZON')       | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-03 | *      |

  @fixture.xts
  Scenario: [BQ-XTS-INC-004] Loads from a single stage to multiple satellites and a pre-populated xts
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1992-12-31 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1992-12-31 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1992-12-31 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BQ-XTS-INC-005] Loads from numerous stages each containing feeds to one satellite and a pre-populated xts
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('EDWARD\|\|1001\|\|EDEN')   | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('FRED\|\|1002\|\|FIELD')    | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE_1 table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_1 data
    And the RAW_STAGE_2 table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2 data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                          | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('EDWARD\|\|1001\|\|EDEN')     | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('FRED\|\|1002\|\|FIELD')      | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')  | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [BQ-XTS-INC-006] Loads from numerous stages each containing feeds to multiple satellites and a pre-populated xts
    Given I have an empty RAW_STAGE_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_2SAT_1 table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT_1 data
    And the RAW_STAGE_2SAT_2 table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT_2 data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1992-12-31 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1992-12-31 | *      |
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
  Scenario: [BQ-XTS-INC-007] Null unique identifier values are not loaded into an pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-12-31 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |