Feature: [XTS-INC] Extended Record Tracking Satellites

  @fixture.xts
  Scenario: [XTS-INC-01] Load multiple subsequent stages into a single stage XTS with no timeline change
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
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
  Scenario: [XTS-INC-02] Load duplicated data into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
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
  Scenario: [XTS-INC-03] Subsequent loads with no timeline change into a pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                  | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1000') | md5('ZAK\|\|1000\|\|ZON') | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1000        | Zak                | Zon               | 1992-12-25   | 17-214-233-1234 | Cambridgeshire  | Cambridge     | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1000        | Zak                | Zon               | 1992-12-25   | 17-214-233-1234 | Cambridgeshire  | Cambridge     | 1993-01-02 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
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
  Scenario: [XTS-INC-04] Loads from a single stage to multiple satellites and a pre-populated xts
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1992-12-31 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
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
  Scenario: [XTS-INC-05] Loads from numerous stages each containing feeds to one satellite and a pre-populated xts
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | md5('EDWARD\|\|1001\|\|EDEN')   | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('FRED\|\|1002\|\|FIELD')    | SAT_CUSTOMER   | 1992-12-31 | *      |
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
  Scenario: [XTS-INC-06] Loads from numerous stages each containing feeds to multiple satellites and a pre-populated xts
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1992-12-31 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
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
  Scenario: [XTS-INC-07] Null unique identifier values are not loaded into an pre-populated XTS
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
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

  @fixture.xts
  Scenario: [XTS-INC-08] (1 SAT) Load mixed stage + empty into non existent XTS - one cycle
    Given the XTS table does not exist
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-INC-09] (1 SAT) Load mixed stages into non existent XTS - two cycles
    Given the XTS table does not exist
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-03 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-03 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-03 | *      |
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                          | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')     | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')      | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')     | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')      | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER') | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')  | SAT_CUSTOMER   | 1993-01-03 | *      |
      | md5('1009') | md5('BILL\|\|1009\|\|WAREN')      | SAT_CUSTOMER   | 1993-01-03 | *      |

  @fixture.xts
  Scenario: [XTS-INC-10] (1 SAT) Load mixed stage + empty stage into empty XTS - two cycles
    Given I have an empty RAW_STAGE_CUSTOMER raw stage
    And I have an empty STG_CUSTOMER primed stage
    And the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-INC-11] (1 SAT) Load mixed stage + empty stage into a pre-populated XTS - two cycles
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1218 | Hampshire       | Southampton   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                          | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1993-12-31 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')     | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')      | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER') | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')  | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1009') | md5('BILL\|\|1009\|\|WAREN')      | SAT_CUSTOMER   | 1993-01-02 | *      |

  @fixture.xts
  Scenario: [XTS-INC-12] (1 SAT) Load mixed stages into a pre-populated XTS - two cycles
    Given the XTS xts is already populated with data
      | CUSTOMER_PK | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1218 | Hampshire       | Southampton   | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS xts
    Then the XTS table should contain expected data
      | CUSTOMER_PK | HASHDIFF                          | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')   | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')       | SAT_CUSTOMER   | 1993-12-31 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')      | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')     | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')      | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER') | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')  | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1009') | md5('BILL\|\|1009\|\|WAREN')      | SAT_CUSTOMER   | 1993-01-02 | *      |

  @fixture.xts
  Scenario: [XTS-INC-13] (2 SATs) Load mixed stage + empty into non existent XTS - one cycle
    Given the XTS_2SAT table does not exist
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 18-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE | SOURCE |
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
      | md5('1002') | md5('2006-04-17\|\|1002\|\|18-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-INC-14] (2 SATs) Load mixed stages into non existent XTS - two cycles
    Given the XTS_2SAT table does not exist
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1002        | Bob                | Barns             | 2006-04-17   | 18-214-233-1215 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-03 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-03 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-03 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-03 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 17-214-233-1224 | Somerset        | Bath          | 1993-01-03 | *      |
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')                | SAT_CUSTOMER         | 1993-01-03 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')                 | SAT_CUSTOMER         | 1993-01-03 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER')            | SAT_CUSTOMER         | 1993-01-03 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')             | SAT_CUSTOMER         | 1993-01-03 | *      |
      | md5('1009') | md5('BILL\|\|1009\|\|WAREN')                 | SAT_CUSTOMER         | 1993-01-03 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|18-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1219') | SAT_CUSTOMER_DETAILS | 1993-01-03 | *      |
      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1220') | SAT_CUSTOMER_DETAILS | 1993-01-03 | *      |
      | md5('1006') | md5('2006-04-17\|\|1006\|\|17-214-233-1221') | SAT_CUSTOMER_DETAILS | 1993-01-03 | *      |
      | md5('1007') | md5('2013-02-04\|\|1007\|\|17-214-233-1222') | SAT_CUSTOMER_DETAILS | 1993-01-03 | *      |
      | md5('1008') | md5('2018-04-13\|\|1008\|\|17-214-233-1223') | SAT_CUSTOMER_DETAILS | 1993-01-03 | *      |
      | md5('1009') | md5('2003-11-04\|\|1009\|\|17-214-233-1224') | SAT_CUSTOMER_DETAILS | 1993-01-03 | *      |

  @fixture.xts
  Scenario: [XTS-INC-15] (2 SATs) Load mixed stage + empty stage into empty XTS - two cycles
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 18-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE | SOURCE |
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
      | md5('1002') | md5('2006-04-17\|\|1002\|\|18-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-INC-16] (2 SATs) Load mixed stages into empty XTS - two cycles
    Given I have an empty RAW_STAGE_CUSTOMER_2SAT raw stage
    And I have an empty STG_CUSTOMER_2SAT primed stage
    And the XTS_2SAT xts is empty
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 18-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT xts
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-02 | *      |
      | 1009        | Bill               | Waren             | 2003-11-04   | 17-214-233-1224 | Somerset        | Bath          | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the XTS_2SAT xts
    Then the XTS_2SAT table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')                | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')                 | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER')            | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')             | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1009') | md5('BILL\|\|1009\|\|WAREN')                 | SAT_CUSTOMER         | 1993-01-02 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|18-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1219') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1220') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1006') | md5('2006-04-17\|\|1006\|\|17-214-233-1221') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1007') | md5('2013-02-04\|\|1007\|\|17-214-233-1222') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1008') | md5('2018-04-13\|\|1008\|\|17-214-233-1223') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
      | md5('1009') | md5('2003-11-04\|\|1009\|\|17-214-233-1224') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |

  #TODO: no way at present to start a test scenario with a pre-populated multi satellite xts
#  @fixture.xts
#  Scenario: [XTS-INC-17] (2 SATs) Load mixed stage + empty stage into a pre-populated XTS - two cycles
#    Given the XTS_2SAT xts is already populated with data
#      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-12-31 | *      |
#      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-12-31 | *      |
#      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-12-31 | *      |
#      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-12-31 | *      |
#    And the RAW_STAGE_CUSTOMER_2SAT table contains data
#      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE | SOURCE |
#    And I stage the STG_CUSTOMER_2SAT data
#    And I load the XTS_2SAT xts
#    And the RAW_STAGE_CUSTOMER_2SAT table contains data
#      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
#      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
#      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
#      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
#      | 1006        | Fred               | Field             | 2005-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
#      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
#      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-02 | *      |
#      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | *      |
#    And I stage the STG_CUSTOMER_2SAT data
#    When I load the XTS_2SAT xts
#    Then the XTS_2SAT table should contain expected data
#      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1992-12-31 | *      |
#      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-12-31 | *      |
#      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')                | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')                 | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER')            | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')             | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1009') | md5('BILL\|\|1009\|\|WAREN')                 | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-12-31 | *      |
#      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1219') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1220') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1006') | md5('2006-04-17\|\|1006\|\|17-214-233-1221') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1006') | md5('2005-04-17\|\|1006\|\|17-214-233-1221') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1007') | md5('2013-02-04\|\|1007\|\|17-214-233-1222') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1008') | md5('2018-04-13\|\|1008\|\|17-214-233-1223') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1009') | md5('2003-11-04\|\|1009\|\|17-214-233-1224') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#
#  @fixture.xts
#  Scenario: [XTS-INC-18] (2 SATs) Load mixed stage into prepopulated XTS - two cycles
#    Given the XTS_2SAT xts is already populated with data
#      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1993-12-31 | *      |
#      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-12-31 | *      |
#      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-12-31 | *      |
#      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-12-31 | *      |
#    And the RAW_STAGE_CUSTOMER_2SAT table contains data
#      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
#      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
#      | <null>      | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
#      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
#      | 1002        | Bob                | Barns             | 2006-04-17   | 18-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
#      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
#      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
#      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1218 | Hampshire       | Southampton   | 1993-01-01 | *      |
#    And I stage the STG_CUSTOMER_2SAT data
#    And I load the XTS_2SAT xts
#    And the RAW_STAGE_CUSTOMER_2SAT table contains data
#      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
#      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1219 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
#      | 1005        | Edward             | Eden              | 1997-04-24   | 17-214-233-1220 | Oxfordshire     | Oxford        | 1993-01-02 | *      |
#      | 1006        | Fred               | Field             | 2006-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
#      | 1006        | Fred               | Field             | 2005-04-17   | 17-214-233-1221 | Wiltshire       | Swindon       | 1993-01-02 | *      |
#      | 1007        | George             | Gardener          | 2013-02-04   | 17-214-233-1222 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
#      | 1008        | Heather            | Hughes            | 2018-04-13   | 17-214-233-1223 | East Sussex     | Brighton      | 1993-01-02 | *      |
#      | 1009        | Bill               | Waren             | 2003-11-04   | 18-214-233-1214 | Somerset        | Bath          | 1993-01-02 | *      |
#    And I stage the STG_CUSTOMER_2SAT data
#    When I load the XTS_2SAT xts
#    Then the XTS_2SAT table should contain expected data
#      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | LOAD_DATE  | SOURCE |
#      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | 1992-12-31 | *      |
#      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-12-31 | *      |
#      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | 1993-01-01 | *      |
#      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | 1993-01-01 | *      |
#      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | 1993-01-01 | *      |
#      | md5('1005') | md5('EDWARD\|\|1005\|\|EDEN')                | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1006') | md5('FRED\|\|1006\|\|FIELD')                 | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1007') | md5('GEORGE\|\|1007\|\|GARDENER')            | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1008') | md5('HEATHER\|\|1008\|\|HUGHES')             | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1009') | md5('BILL\|\|1009\|\|WAREN')                 | SAT_CUSTOMER         | 1993-01-02 | *      |
#      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1002') | md5('2006-04-17\|\|1002\|\|18-214-233-1215') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | 1993-01-01 | *      |
#      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1219') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1005') | md5('1997-04-24\|\|1005\|\|17-214-233-1220') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1006') | md5('2006-04-17\|\|1006\|\|17-214-233-1221') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1006') | md5('2005-04-17\|\|1006\|\|17-214-233-1221') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1007') | md5('2013-02-04\|\|1007\|\|17-214-233-1222') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1008') | md5('2018-04-13\|\|1008\|\|17-214-233-1223') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |
#      | md5('1009') | md5('2003-11-04\|\|1009\|\|17-214-233-1224') | SAT_CUSTOMER_DETAILS | 1993-01-02 | *      |

  @fixture.xts
  Scenario: [XTS-INC-19] (2 SATs) Load mixed stage + empty into non existent XTS with additional columns - one cycle
    Given the XTS_2SAT_AC table does not exist
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 18-214-233-1215 | Wiltshire       | Swindon       | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | <null>      | Greg               | Stewart           | 2018-04-13   | 17-214-233-1218 | Kent            | Ashford       | TPCH_CUSTOMER  | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_2SAT data
    And I load the XTS_2SAT_AC xts
    And the RAW_STAGE_CUSTOMER_2SAT table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_COUNTY | CUSTOMER_CITY | CUSTOMER_MT_ID | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER_2SAT data
    When I load the XTS_2SAT_AC xts
    Then the XTS_2SAT_AC table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                     | SATELLITE_NAME       | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('ALICE\|\|1001\|\|ANDREWS')              | SAT_CUSTOMER         | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1002') | md5('BOB\|\|1002\|\|BARNS')                  | SAT_CUSTOMER         | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1003') | md5('CHAD\|\|1003\|\|CLARKE')                | SAT_CUSTOMER         | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1004') | md5('DOM\|\|1004\|\|DAVIES')                 | SAT_CUSTOMER         | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1001') | md5('1997-04-24\|\|1001\|\|17-214-233-1214') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|17-214-233-1215') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1002') | md5('2006-04-17\|\|1002\|\|18-214-233-1215') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1003') | md5('2013-02-04\|\|1003\|\|17-214-233-1216') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER  | 1993-01-01 | *      |
      | md5('1004') | md5('2018-04-13\|\|1004\|\|17-214-233-1217') | SAT_CUSTOMER_DETAILS | TPCH_CUSTOMER  | 1993-01-01 | *      |

