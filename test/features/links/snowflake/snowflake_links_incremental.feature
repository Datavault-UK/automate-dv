Feature: [SF-LNK] Links loaded using Incremental Materialization

  @fixture.single_source_link
  Scenario: [SF-LNK-IM-01] Load of empty stage data into a non-existent link - one cycle
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-IM-02] Load of stage data into a non-existent link - one cycle
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-IM-03] Load of stage data into a non-existent link - two cycles
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1011        | GHA       | Sam           | 1970-08-09   | 17-214-233-1221 | 1993-01-04 | CRM    |
      | 1012        | MEX       | Ron           | 2000-05-13   | 17-214-233-1222 | 1993-01-04 | CRM    |
      | 1013        | GBR       | Luke          | 1976-09-04   | 17-214-233-1223 | 1993-01-04 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|ITA') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|DEU') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|ITA') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |
      | md5('1011\|\|GHA') | md5('1011') | md5('GHA') | 1993-01-04 | CRM    |
      | md5('1012\|\|MEX') | md5('1012') | md5('MEX') | 1993-01-04 | CRM    |
      | md5('1013\|\|GBR') | md5('1013') | md5('GBR') | 1993-01-04 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-IM-04] Load of empty stage data into an empty link - two cycles
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-IM-05] Load of stage data into an empty link - one cycle
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |


      @fixture.single_source_link
  Scenario: [SF-LNK-IM-06] Load of stage data into an empty link - two cycles
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-IM-07] Load of empty stage data into a populated link - one cycle
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-IM-08] Load of stage data into a populated link - one cycle
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-IM-06] Load of stage data into a populated link - two cycles
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|ITA') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|DEU') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|ITA') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |
