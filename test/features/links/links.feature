Feature: [LNK] Links

  @fixture.single_source_link
  Scenario: [LNK-01] Load a simple stage table into a non-existent link table
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-02] Load a stage table with duplicates into a non-existent link table
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-03] Load a simple stage table into a non-existent link and exclude records with NULL foreign keys
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007        | <null>    | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-04] Load a simple stage table into an empty link table
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-05] Load a stage table with duplicates into an empty link table
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  @fixture.single_source_link
  Scenario: [LNK-06] Load a simple stage table into a populated link.
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
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
  Scenario: [LNK-07] Load a stage table with duplicates into a populated link
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
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
  Scenario: [LNK-08] Load a stage table where a foreign key is NULL, no link is inserted
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007        | <null>    | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
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
  Scenario: [LNK-09] Load a stage table where a primary keys components are all NULL, no link is inserted
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | <null>      | <null>    | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |

  @fixture.multi_source_link
  Scenario: [LNK-10] Union three staging tables to feed a link which does not exist
    Given the LINK table does not exist
    And the RAW_STAGE_SAP table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And I stage the STG_SAP data
    And the RAW_STAGE_CRM table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CRM data
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006        | DEU       | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008        | AUS       | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010        | ITA       | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And I stage the STG_WEB data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | SAP    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | SAP    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | WEB    |

  @fixture.multi_source_link
  Scenario: [LNK-11] Union three staging tables to feed empty link
    Given the LINK link is empty
    And the RAW_STAGE_SAP table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And I stage the STG_SAP data
    And the RAW_STAGE_CRM table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CRM data
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006        | DEU       | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008        | AUS       | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010        | ITA       | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And I stage the STG_WEB data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | SAP    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | SAP    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | WEB    |

  @fixture.multi_source_link
  Scenario: [LNK-12] Union three staging tables to feed empty link where NULL foreign keys are not added
    Given the LINK link is empty
    And the RAW_STAGE_SAP table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | <null>      | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And I stage the STG_SAP data
    And the RAW_STAGE_CRM table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | <null>      | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CRM data
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006        | DEU       | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008        | AUS       | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010        | <null>    | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And I stage the STG_WEB data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | SAP    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | SAP    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |

  @fixture.multi_source_link
  Scenario: [LNK-13] Union three staging tables with duplicates to feed populated link
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE_SAP table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And I stage the STG_SAP data
    And the RAW_STAGE_CRM table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CRM data
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006        | DEU       | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1008        | AUS       | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010        | ITA       | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And I stage the STG_WEB data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | WEB    |

  @fixture.multi_source_link
  Scenario: [LNK-14] Load a stage table where a foreign key is NULL, no link is inserted
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE_SAP table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | <null>    | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | <null>    | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And I stage the STG_SAP data
    And the RAW_STAGE_CRM table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003        | <null>    | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CRM data
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006        | DEU       | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1008        | AUS       | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010        | <null>    | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And I stage the STG_WEB data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | WEB    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | WEB    |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | WEB    |

  @fixture.single_source_link
  Scenario: [LNK-15] Standard base load of a link with additional columns added
    Given the LINK_AC table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_MT_ID | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | TPCH_CUSTOMER  | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | TPCH_CUSTOMER  | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | TPCH_CUSTOMER  | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006        | DEU       | Chad          | TPCH_CUSTOMER  | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007        | ITA       | Dom           | TPCH_CUSTOMER  | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK_AC link
    Then the LINK_AC table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | CUSTOMER_MT_ID | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | TPCH_CUSTOMER  | 1993-01-01 | CRM    |
