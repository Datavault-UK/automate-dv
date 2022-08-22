Feature: [LNK] Links loaded using Incremental Materialization

  @fixture.single_source_link
  Scenario: [LNK-IM-01] Load of empty stage data into a non-existent link - one cycle
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-02] Load of mixed stage data into a non-existent link - one cycle
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
  Scenario: [LNK-IM-03] Load of mixed stage data into a non-existent link - two cycles
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
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-04 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-04 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-04 | CRM    |
      | 1008        | GBR       | Fredie        | 2008-01-04   | 17-214-233-1218 | 1993-01-04 | CRM    |
      | 1009        | PHI       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-04 | CRM    |
      | 1020        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-04 | CRM    |
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
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-04 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-04 | CRM    |
      | md5('1009\|\|PHI') | md5('1009') | md5('PHI') | 1993-01-04 | CRM    |
      | md5('1020\|\|IND') | md5('1020') | md5('IND') | 1993-01-04 | CRM    |
      | md5('1011\|\|GHA') | md5('1011') | md5('GHA') | 1993-01-04 | CRM    |
      | md5('1012\|\|MEX') | md5('1012') | md5('MEX') | 1993-01-04 | CRM    |
      | md5('1013\|\|GBR') | md5('1013') | md5('GBR') | 1993-01-04 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-04] Load of stage data + empty stage data into an empty link - two cycles
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-05] Load of stage data into an empty link - one cycle
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
  Scenario: [LNK-IM-06] Load of mixed stage data into an empty link - two cycles
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
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
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
  Scenario: [LNK-IM-07] Load of empty stage data into a populated link - one cycle
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-08] Load of mixed stage data into a populated link - one cycle
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alicia        | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1005        | CHN       | Erik          | 1990-01-01   | 17-214-233-1218 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dominic       | 1993-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1005\|\|CHN') | md5('1005') | md5('CHN') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-09] Load of mixed stage data into a populated link - two cycles
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | LAT       | Ivan          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | FIN       | Kimi          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | George        | 1994-02-22   | 17-214-233-1201 | 1993-01-03 | CRM    |
      | 1002        | POLO      | Aga           | 1956-10-17   | 17-214-233-1202 | 1993-01-03 | CRM    |
      | 1004        | ROU       | Viorel        | 1988-09-09   | 17-214-233-1203 | 1993-01-03 | CRM    |
      | 1015        | ITA       | Andrea        | 1978-05-19   | 17-214-233-1204 | 1993-01-03 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | LIT       | Ivan          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | FIN       | Kimi          | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | USA       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK  | CUSTOMER_FK | NATION_FK   | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR')  | md5('1001') | md5('GBR')  | 1993-01-01 | CRM    |
      | md5('1002\|\|POL')  | md5('1002') | md5('POL')  | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU')  | md5('1004') | md5('DEU')  | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA')  | md5('1005') | md5('ITA')  | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS')  | md5('1003') | md5('AUS')  | 1993-01-02 | CRM    |
      | md5('1006\|\|LAT')  | md5('1006') | md5('LAT')  | 1993-01-02 | CRM    |
      | md5('1007\|\|FIN')  | md5('1007') | md5('FIN')  | 1993-01-02 | CRM    |
      | md5('1002\|\|POLO') | md5('1002') | md5('POLO') | 1993-01-03 | CRM    |
      | md5('1004\|\|ROU')  | md5('1004') | md5('ROU')  | 1993-01-03 | CRM    |
      | md5('1006\|\|LIT')  | md5('1006') | md5('LIT')  | 1993-01-03 | CRM    |
      | md5('1017\|\|FIN')  | md5('1017') | md5('FIN')  | 1993-01-03 | CRM    |
      | md5('1008\|\|USA')  | md5('1008') | md5('USA')  | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA')  | md5('1009') | md5('FRA')  | 1993-01-03 | CRM    |
      | md5('1010\|\|IND')  | md5('1010') | md5('IND')  | 1993-01-03 | CRM    |
      | md5('1015\|\|ITA')  | md5('1015') | md5('ITA')  | 1993-01-03 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-10] Load of empty stage data into a non-existent link with additional columns - one cycle
    Given the LINK_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK_AC link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE | CUSTOMER_MT_ID | LOAD_DATE | SOURCE |
    And I stage the STG_CUSTOMER data
    When I load the LINK_AC link
    Then the LINK_AC table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-11] Load of stage data into an empty link with additional columns - one cycle
    Given the LINK_AC link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK_AC link
    Then the LINK_AC table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-12] Load of mixed stage data into a non-existent link with additional columns - two cycles
    Given the LINK_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK_AC link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | TPCH_CUSTOMER  | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | TPCH_CUSTOMER  | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | TPCH_CUSTOMER  | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK_AC link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1008        | GBR       | Fredie        | 2008-01-04   | 17-214-233-1218 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1009        | PHI       | Charles       | 1995-11-14   | 17-214-233-1219 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1020        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1011        | GHA       | Sam           | 1970-08-09   | 17-214-233-1221 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1012        | MEX       | Ron           | 2000-05-13   | 17-214-233-1222 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | 1013        | GBR       | Luke          | 1976-09-04   | 17-214-233-1223 | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK_AC link
    Then the LINK_AC table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | TPCH_CUSTOMER  | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | TPCH_CUSTOMER  | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | TPCH_CUSTOMER  | 1993-01-03 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | md5('1009\|\|PHI') | md5('1009') | md5('PHI') | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | md5('1020\|\|IND') | md5('1020') | md5('IND') | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | md5('1011\|\|GHA') | md5('1011') | md5('GHA') | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | md5('1012\|\|MEX') | md5('1012') | md5('MEX') | TPCH_CUSTOMER  | 1993-01-04 | CRM    |
      | md5('1013\|\|GBR') | md5('1013') | md5('GBR') | TPCH_CUSTOMER  | 1993-01-04 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-IM-13] Load of mixed stage data into a populated link with additional columns - one cycle
    Given the LINK_AC link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alicia        | 1997-04-24   | 17-214-233-1214 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1005        | CHN       | Erik          | 1990-01-01   | 17-214-233-1218 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dominic       | 1993-01-01   | 17-214-233-1217 | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK_AC link
    Then the LINK_AC table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1005\|\|CHN') | md5('1005') | md5('CHN') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-02 | CRM    |
