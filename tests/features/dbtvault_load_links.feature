Feature: Load Links
# =============================================================================
# CHANGE HISTORY
# ==============
#
# Date     Who Version Details
# -------- --- ------- --------------------------------------------------------
# 21.06.19 CF  1.0     First release.
# 09.07.19 CF  1.1     Updated to test the sql used by dbt.
# 24.09.19 NS  1.2     Reviewed and updated.
# =============================================================================

# -----------------------------------------------------------------------------
# Testing insertion of records into a link which doesn't yet exist
# -----------------------------------------------------------------------------
  Scenario: [BASE-LOAD-SINGLE] Load a simple stage table into an empty link table
    Given a TEST_LINK_CUSTOMER_NATION table does not exist
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  Scenario: [SINGLE-SOURCE] Load a stage table with duplicates into an empty link table
    Given I have an empty LINK_CUSTOMER_NATION table
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |

    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  Scenario: [BASE-LOAD-SINGLE] Load a simple stage table into an empty link table and exclude Links with NULL foreign keys
    Given a TEST_LINK_CUSTOMER_NATION table does not exist
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | <null>     | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |

# -----------------------------------------------------------------------------
# Test the load of one stage table feeding an empty link.
# -----------------------------------------------------------------------------
  Scenario: [SINGLE-SOURCE] Load a simple stage table into an empty link table
    Given I have an empty LINK_CUSTOMER_NATION table
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |

  Scenario: [SINGLE-SOURCE] Load a stage table with duplicates into an empty link table
    Given I have an empty LINK_CUSTOMER_NATION table
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-01 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-01 | CRM    |

    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |


# -----------------------------------------------------------------------------
# Test the load of one stage table feeding a populated link.
# -----------------------------------------------------------------------------
  Scenario: [SINGLE-SOURCE] Load a simple stage table into a populated link.
    Given there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  Scenario: [SINGLE-SOURCE] Load a stage table with duplicates into a populated link.
    Given there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |

  Scenario: [SINGLE-SOURCE] Load a stage table where a foreign key is NULL, no link is inserted.
    Given there are records in the TEST_STG_CRM_CUSTOMER table
     | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
     | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
     | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
     | 1002         | POL        | Alice         | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
     | 1003         | AUS        | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
     | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
     | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
     | 1006         | DEU        | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
     | 1007         | ITA        | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
     | 1007         | <null>     | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the LINK_CUSTOMER_NATION table
     | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
     | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
     | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
     | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
     | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION table
    Then the LINK_CUSTOMER_NATION table should contain
     | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
     | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
     | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
     | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
     | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
     | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
     | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
     | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |


# -----------------------------------------------------------------------------------------
# Test union of different staging tables to insert records into links which don't yet exist
# -----------------------------------------------------------------------------------------
  Scenario: [BASE-LOAD-UNION] Union three staging tables to feed a link which does not exist.
    Given a TEST_LINK_CUSTOMER_NATION_UNION table does not exist
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | ITA        | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | *      |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | *      |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | *      |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | *      |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | *      |

# -----------------------------------------------------------------------------
# Test the union of three stage tables feeding an empty link.
# -----------------------------------------------------------------------------
  Scenario: [UNION] Union three staging tables to feed empty link.
    Given I have an empty LINK_CUSTOMER_NATION_UNION table
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | ITA        | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | *      |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | *      |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | *      |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | *      |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | *      |

  Scenario: [UNION] Union three staging tables with duplicates to feed populated link.
    Given I have an empty LINK_CUSTOMER_NATION_UNION table
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | ITA        | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And there are records in the LINK_CUSTOMER_NATION_UNION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | *      |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | *      |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | *      |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | *      |
      | md5('1010\|\|ITA') | md5('1010') | md5('ITA') | 1993-01-02 | *      |

  Scenario: [UNION] Load a stage table where a foreign key is NULL, no link is inserted.
    Given there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1003        | <null>    | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | <null>    | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1003         | <null>     | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | <null>     | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    And there are records in the LINK_CUSTOMER_NATION_UNION table
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | CRM    |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | CRM    |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | CRM    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-01 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-01 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-01 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-01 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | *      |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | *      |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | *      |

   Scenario: [UNION] Union three staging tables to feed empty link where NULL foreign keys are not added.
    Given I have an empty LINK_CUSTOMER_NATION_UNION table
    And there are records in the TEST_STG_SAP_CUSTOMER table
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001        | GBR       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | 1002        | POL       | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | SAP    |
      | <null>      | AUS       | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | SAP    |
      | 1004        | DEU       | Dave          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | SAP    |
      | 1005        | ITA       | Eric          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | SAP    |
    And there are records in the TEST_STG_CRM_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | 1002         | POL        | Bob           | 2006-04-17   | 17-214-233-1214 | 1993-01-02 | CRM    |
      | <null>       | AUS        | Chris         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1007         | ITA        | Grigor        | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And there are records in the TEST_STG_WEB_CUSTOMER table
      | CUSTOMER_REF | NATION_KEY | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOADDATE   | SOURCE |
      | 1001         | GBR        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-02 | WEB    |
      | 1006         | DEU        | Fred          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1008         | AUS        | Hal           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | WEB    |
      | 1009         | DEU        | Ingrid        | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | WEB    |
      | 1010         | <null>     | Jack          | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | WEB    |
    When I load the TEST_LINK_CUSTOMER_NATION_UNION table
    Then the LINK_CUSTOMER_NATION_UNION table should contain
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOADDATE   | SOURCE |
      | md5('1001\|\|GBR') | md5('1001') | md5('GBR') | 1993-01-02 | *      |
      | md5('1002\|\|POL') | md5('1002') | md5('POL') | 1993-01-02 | *      |
      | md5('1004\|\|DEU') | md5('1004') | md5('DEU') | 1993-01-02 | *      |
      | md5('1005\|\|ITA') | md5('1005') | md5('ITA') | 1993-01-02 | *      |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | *      |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | *      |
      | md5('1008\|\|AUS') | md5('1008') | md5('AUS') | 1993-01-02 | *      |
      | md5('1009\|\|DEU') | md5('1009') | md5('DEU') | 1993-01-02 | *      |