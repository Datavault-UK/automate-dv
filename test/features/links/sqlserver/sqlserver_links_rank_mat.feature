Feature: [SF-LNK-RM] Links Loaded using Rank Materialization

  @fixture.single_source_link
  Scenario: [SF-LNK-RM-001] Load a simple stage table into a non-existent link table
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-04 | CRM    |
    And I have a rank column DBTVAULT_RANK in the STG_CUSTOMER stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CUSTOMER data
    And I insert by rank into the LINK link
    And I insert by rank into the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-03 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-04 | CRM    |

  @fixture.multi_source_link
  Scenario: [SF-LNK-RM-002] Union three staging tables to feed empty link
    Given the LINK link is empty
    And the RAW_STAGE_SAP table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_SAP stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_SAP data
    And the RAW_STAGE_CRM table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-03 | *      |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-03 | *      |
      | 1007        | ITA       | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_CRM stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_CRM data
    And the RAW_STAGE_WEB table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-04 | *      |
      | 1006        | DEU       | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-04 | *      |
      | 1008        | AUS       | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-04 | *      |
      | 1009        | DEU       | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-04 | *      |
    And I have a rank column DBTVAULT_RANK in the STG_WEB stage partitioned by CUSTOMER_ID and ordered by LOAD_DATE
    And I stage the STG_WEB data
    And I insert by rank into the LINK link
    And I insert by rank into the LINK link
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-04 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-03 | *      |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-04 | *      |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-04 | *      |