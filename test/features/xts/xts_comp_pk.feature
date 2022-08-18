Feature: [XTS-COMP-PK] Extended Record Tracking Satellites with composite PK

  @fixture.xts
  Scenario: [XTS-COMP-PK-01] Load one stage of records into an empty single satellite XTS
    Given the XTS xts is empty
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS_COMP_PK xts
    Then the XTS_COMP_PK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_PHONE  | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | 17-214-233-1214 | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | 17-214-233-1215 | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | 17-214-233-1216 | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | 17-214-233-1217 | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-COMP-PK-02] Load record into a pre-populated XTS
    Given the XTS_COMP_PK xts is already populated with data
      | CUSTOMER_PK | CUSTOMER_PHONE  | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | 17-214-233-1214 | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | 17-214-233-1215 | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-01 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS_COMP_PK xts
    Then the XTS_COMP_PK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_PHONE  | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | 17-214-233-1214 | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | 17-214-233-1215 | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | 17-214-233-1214 | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | 17-214-233-1215 | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | 17-214-233-1216 | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1004') | 17-214-233-1217 | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-01 | *      |

  @fixture.xts
  Scenario: [XTS-COMP-PK-03] Load record into a pre-populated XTS
    Given the XTS_COMP_PK xts is already populated with data
      | CUSTOMER_PK | CUSTOMER_PHONE  | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | 17-214-233-1214 | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | 17-214-233-1215 | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1992-12-31 | *      |
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1001        | Alice              | Andrews           | 1997-04-24   | 17-214-233-1214 | Oxfordshire     | Oxford        | 1993-01-01 | *      |
      | 1002        | Bob                | Barns             | 2006-04-17   | 17-214-233-1215 | Wiltshire       | Swindon       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    And I load the XTS_COMP_PK xts
    And the RAW_STAGE_CUSTOMER table contains data
      | CUSTOMER_ID | CUSTOMER_FIRSTNAME | CUSTOMER_LASTNAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_COUNTY | CUSTOMER_CITY | LOAD_DATE  | SOURCE |
      | 1003        | Chad               | Clarke            | 2013-02-04   | 17-214-233-1216 | Lincolnshire    | Lincoln       | 1993-01-02 | *      |
      | 1004        | Dom                | Davies            | 2018-04-13   | 17-214-233-1217 | East Sussex     | Brighton      | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the XTS_COMP_PK xts
    Then the XTS_COMP_PK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_PHONE  | HASHDIFF                        | SATELLITE_NAME | LOAD_DATE  | SOURCE |
      | md5('1001') | 17-214-233-1214 | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1002') | 17-214-233-1215 | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1992-12-31 | *      |
      | md5('1001') | 17-214-233-1214 | md5('ALICE\|\|1001\|\|ANDREWS') | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1002') | 17-214-233-1215 | md5('BOB\|\|1002\|\|BARNS')     | SAT_CUSTOMER   | 1993-01-01 | *      |
      | md5('1003') | 17-214-233-1216 | md5('CHAD\|\|1003\|\|CLARKE')   | SAT_CUSTOMER   | 1993-01-02 | *      |
      | md5('1004') | 17-214-233-1217 | md5('DOM\|\|1004\|\|DAVIES')    | SAT_CUSTOMER   | 1993-01-02 | *      |

