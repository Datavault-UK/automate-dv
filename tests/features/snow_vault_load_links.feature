@test_data
Feature: Load Links
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 21.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# =============================================================================

  Scenario: [SINGLE-SOURCE] Distinct history of data linking two hubs is loaded into a link table
    Given there are records in the TEST_STG_CUSTOMER table for links
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CUST   |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CUST   |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CUST   |
      | 1004        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CUST   |
      | 1005        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CUST   |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    When I run a fresh dbt link load
    Then only distinct records from the STG_CUSTOMER_NATION are loaded into the link
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | *      |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | *      |

  Scenario: [SINGLE-SOURCE] Unchanged records in stage are not loaded into the link with pre-existing data
    Given there are records in the TEST_STG_CUSTOMER table for links
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CUST   |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | *      |
    When I run a dbt link load
    Then only different or unchanged records are loaded to the link
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | *      |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | *      |


  Scenario: [SINGLE-SOURCE] Only the first instance of a record is loaded into the link table for the history
    Given there are records in the TEST_STG_CUSTOMER table for links
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CUST   |
      | 1002        | POL       | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CUST   |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CUST   |
      | 1004        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CUST   |
      | 1005        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CUST   |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CUST   |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CUST   |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I run a dbt link load
    Then only the first seen distinct records are loaded into the link
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | *      |