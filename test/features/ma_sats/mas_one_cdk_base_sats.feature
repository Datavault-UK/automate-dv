Feature: [MAS-1CD] Multi Active Satellites
  Base satellite behaviour with one CDK

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-01] Load data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-02] Load duplicated data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                | CUSTOMER_NAME | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214') | Alice         | 17-214-233-1214 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215')   | Bob           | 17-214-233-1215 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216')  | Chad          | 17-214-233-1216 | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217')   | Dom           | 17-214-233-1217 | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-03] Load data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE ma_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')    | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-04] Load data into an empty multi-active satellite where some records have NULL PK(s), CDK(s) and Attribute(s)
    Given the MULTI_ACTIVE_SATELLITE ma_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1005        | <null>        | 17-214-233-1218 | 1993-01-01 | *      |
      | 1006        | Jenny         | <null>          | 1993-01-01 | *      |
      | <null>      | <null>        | 17-214-233-1219 | 1993-01-01 | *      |
      | <null>      | Frida         | <null>          | 1993-01-01 | *      |
      | <null>      | <null>        | <null>          | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | <null>        | 17-214-233-1218 | md5('1005\|\|^^\|\|17-214-233-1218')    | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-05] Load duplicated data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE ma_sat is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-06] Load data into a populated multi-active satellite where all records load
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | md5('1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | md5('1006\|\|FRIDA\|\|17-214-233-1214') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-07] Load data into a populated satellite where either the PK(s) or the CDK(s) are NULL - with existent PK(s)/CDK(s)
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1212 | md5('1002\|\|BOB\|\|17-214-233-1212')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1214 | md5('1004\|\|DOM\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | md5('1006\|\|FRIDA\|\|17-214-233-1216') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1008') | Jenny         | 17-214-233-1218 | md5('1008\|\|JENNY\|\|17-214-233-1218') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | 17-214-233-1212 | 1993-01-02 | *      |
      | <null>      | Dom           | 17-214-233-1214 | 1993-01-02 | *      |
      | 1006        | <null>        | <null>          | 1993-01-02 | *      |
      | 1008        | Jenny         | <null>          | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1212 | md5('1002\|\|BOB\|\|17-214-233-1212')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1214 | md5('1004\|\|DOM\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | md5('1006\|\|FRIDA\|\|17-214-233-1216') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1008') | Jenny         | 17-214-233-1218 | md5('1008\|\|JENNY\|\|17-214-233-1218') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-08] Load data into a populated satellite where either the PK(s) or the CDK(s) are NULL - with new PK(s)/CDK(s)
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | md5('1004\|\|DOM\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | md5('1006\|\|FRIDA\|\|17-214-233-1216') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | 17-214-233-1213 | 1993-01-02 | *      |
      | <null>      | Dan           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1007        | <null>        | <null>          | 1993-01-02 | *      |
      | 1009        | Jenna         | <null>          | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | md5('1004\|\|DOM\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | md5('1006\|\|FRIDA\|\|17-214-233-1216') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-09] Load data into a populated satellite where the stage records include NULL PK(s) and NULL CDK(s)
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | md5('1004\|\|DOM\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | md5('1006\|\|FRIDA\|\|17-214-233-1216') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | <null>         | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | md5('1004\|\|DOM\|\|17-214-233-1214')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | md5('1006\|\|FRIDA\|\|17-214-233-1216') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-1CD-10] Load data into a populated multi-active satellite where some records overlap
    Given the MULTI_ACTIVE_SATELLITE ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | md5('1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER data
    When I load the MULTI_ACTIVE_SATELLITE ma_sat
    Then the MULTI_ACTIVE_SATELLITE table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | HASHDIFF                                | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | md5('1001\|\|ALICE\|\|17-214-233-1214') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | md5('1002\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | md5('1003\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | md5('1004\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | md5('1005\|\|ERIC\|\|17-214-233-1217')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | md5('1006\|\|FRIDA\|\|17-214-233-1217') | 1993-01-01     | 1993-01-01 | *      |