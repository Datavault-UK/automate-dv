Feature: [LNK-COMP-PK] Links with composite src_pk

  @fixture.single_source_comp_pk_link
  Scenario: [LNK-COMP-PK-01] Load a simple stage table into a non-existent link table
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
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  @fixture.single_source_comp_pk_link
  Scenario: [LNK-COMP-PK-02] Load a simple stage table into an empty link table
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
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  @fixture.single_source_comp_pk_link
  Scenario: [LNK-COMP-PK-03] Load a simple stage table into a populated link table
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
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
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  @fixture.single_source_comp_pk_link
  Scenario: [LNK-COMP-PK-04] Load a stage table where a primary keys components are all NULL, no link is inserted
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | <null>      | <null>    | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |

  @fixture.single_source_comp_pk_link
  Scenario: [LNK-COMP-PK-05] Load a simple stage table into a non-existent link table, period load
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-04 | CRM    |
    And I stage the STG_CUSTOMER data
    And I insert by period into the LINK link by day
    And I insert by period into the LINK link by day
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('1006') | md5('DEU') | 1993-01-03 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('1007') | md5('ITA') | 1993-01-04 | CRM    |

  @fixture.single_source_comp_pk_link
  Scenario: [LNK-COMP-PK-06] Load a simple stage table into a non-existent link table, rank load
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by LOAD_DATE and ordered by CUSTOMER_ID
    And I stage the STG_CUSTOMER data
    And I insert by rank into the LINK link
    And I insert by rank into the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  @fixture.single_source_comp_pk_link
  Scenario: [LNK-COMP-PK-07] Load a simple stage table into a non-existent link table, incremental load
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | COMP_PK     | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
