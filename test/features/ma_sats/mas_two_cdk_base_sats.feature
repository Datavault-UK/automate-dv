Feature: [MAS-2CD] Multi Active Satellites
  Base satellite behaviour with two CDKs

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-01] Load data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK table does not exist
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                       | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | Alice         | 17-214-233-1214 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | Bob           | 17-214-233-1215 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | Chad          | 17-214-233-1216 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | Dom           | 17-214-233-1217 | 123       | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-02] Load duplicated data into a non-existent multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK table does not exist
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                       | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | Alice         | 17-214-233-1214 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | Bob           | 17-214-233-1215 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | Chad          | 17-214-233-1216 | 123       | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | Dom           | 17-214-233-1217 | 123       | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-03] Load data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is empty
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-04] Load duplicated data into an empty multi-active satellite
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is empty
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1217 | 123       | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-05] Load data into an empty multi-active satellite where some records have NULL PK(s), CDK(s) and Attribute(s)
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is empty
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-01 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-01 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 124       | 1993-01-01 | *      |
      | 1004        | Dom           | 17-214-233-1216 | 125       | 1993-01-01 | *      |
      | 1005        | <null>        | 17-214-233-1218 | 123       | 1993-01-01 | *      |
      | 1005        | <null>        | 17-214-233-1218 | <null>    | 1993-01-01 | *      |
      | 1005        | Jenny         | <null>          | <null>    | 1993-01-01 | *      |
      | <null>      | Jenny         | 17-214-233-1228 | <null>    | 1993-01-01 | *      |
      | 1005        | <null>        | <null>          | 123       | 1993-01-01 | *      |
      | <null>      | Jenny         | <null>          | 123       | 1993-01-01 | *      |
      | <null>      | <null>        | 17-214-233-1228 | 123       | 1993-01-01 | *      |
      | <null>      | <null>        | <null>          | 123       | 1993-01-01 | *      |
      | <null>      | <null>        | 17-214-233-1219 | <null>    | 1993-01-01 | *      |
      | <null>      | Frida         | <null>          | <null>    | 1993-01-01 | *      |
      | <null>      | <null>        | <null>          | <null>    | 1993-01-01 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 124       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|124')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1216 | 125       | md5('1004\|\|DOM\|\|17-214-233-1216\|\|125')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | <null>        | 17-214-233-1218 | 123       | md5('1005\|\|^^\|\|17-214-233-1218\|\|123')    | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-06] Load data into a populated multi-active satellite where all records load
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 123       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-02     | 1993-01-02 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 123       | md5('1005\|\|ERIC\|\|17-214-233-1217\|\|123')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1214 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1214\|\|123') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-07] Load data into a populated multi-active satellite where some records overlap
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1217\|\|123') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 17-214-233-1214 | 123       | 1993-01-02 | *      |
      | 1002        | Bob           | 17-214-233-1215 | 123       | 1993-01-02 | *      |
      | 1003        | Chad          | 17-214-233-1216 | 123       | 1993-01-02 | *      |
      | 1005        | Eric          | 17-214-233-1217 | 123       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | Alice         | 17-214-233-1214 | 123       | md5('1001\|\|ALICE\|\|17-214-233-1214\|\|123') | 1993-01-02     | 1993-01-02 | *      |
      | md5('1002') | Bob           | 17-214-233-1215 | 123       | md5('1002\|\|BOB\|\|17-214-233-1215\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1003') | Chad          | 17-214-233-1216 | 123       | md5('1003\|\|CHAD\|\|17-214-233-1216\|\|123')  | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1217 | 123       | md5('1004\|\|DOM\|\|17-214-233-1217\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1005') | Eric          | 17-214-233-1217 | 123       | md5('1005\|\|ERIC\|\|17-214-233-1217\|\|123')  | 1993-01-02     | 1993-01-02 | *      |
      | md5('1006') | Frida         | 17-214-233-1217 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1217\|\|123') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-08] Load data into a populated satellite where either the PK(s) or the CDK(s) are NULL - with existent PK(s)/CDK(s)
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1212 | 123       | md5('1002\|\|BOB\|\|17-214-233-1212\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1214 | 123       | md5('1004\|\|DOM\|\|17-214-233-1214\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1216\|\|123') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1008') | Jenny         | 17-214-233-1218 | 123       | md5('1008\|\|JENNY\|\|17-214-233-1218\|\|123') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | <null>          | 123       | 1993-01-02 | *      |
      | <null>      | <null>        | 17-214-233-1214 | <null>    | 1993-01-02 | *      |
      | <null>      | Dom           | <null>          | <null>    | 1993-01-02 | *      |
      | 1004        | <null>        | <null>          | <null>    | 1993-01-02 | *      |
      | 1004        | <null>        | <null>          | 123       | 1993-01-02 | *      |
      | <null>      | Dom           | 17-214-233-1214 | <null>    | 1993-01-02 | *      |
      | <null>      | Dom           | <null>          | 123       | 1993-01-02 | *      |
      | 1004        | Dom           | 17-214-233-1214 | <null>    | 1993-01-02 | *      |
      | 1004        | Dom           | <null>          | 123       | 1993-01-02 | *      |
      | <null>      | Dom           | 17-214-233-1214 | 123       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1002') | Bob           | 17-214-233-1212 | 123       | md5('1002\|\|BOB\|\|17-214-233-1212\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1004') | Dom           | 17-214-233-1214 | 123       | md5('1004\|\|DOM\|\|17-214-233-1214\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1216\|\|123') | 1993-01-01     | 1993-01-01 | *      |
      | md5('1008') | Jenny         | 17-214-233-1218 | 123       | md5('1008\|\|JENNY\|\|17-214-233-1218\|\|123') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-09] Load data into a populated satellite where either the PK(s) or the CDK(s) are NULL - with new PK(s)/CDK(s)
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | 123       | md5('1004\|\|DOM\|\|17-214-233-1214\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1216\|\|123') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | <null>          | 121       | 1993-01-02 | *      |
      | <null>      | <null>        | 17-214-233-1213 | <null>    | 1993-01-02 | *      |
      | <null>      | Dom           | <null>          | <null>    | 1993-01-02 | *      |
      | 1003        | <null>        | <null>          | <null>    | 1993-01-02 | *      |
      | 1005        | <null>        | <null>          | 122       | 1993-01-02 | *      |
      | <null>      | Dom           | 17-214-233-1215 | <null>    | 1993-01-02 | *      |
      | <null>      | Dom           | <null>          | 124       | 1993-01-02 | *      |
      | 1007        | Dom           | 17-214-233-1217 | <null>    | 1993-01-02 | *      |
      | 1009        | Dom           | <null>          | 125       | 1993-01-02 | *      |
      | <null>      | Dom           | 17-214-233-1219 | 126       | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | 123       | md5('1004\|\|DOM\|\|17-214-233-1214\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1216\|\|123') | 1993-01-01     | 1993-01-01 | *      |

  @fixture.multi_active_satellite
  Scenario: [MAS-2CD-10] Load data into a populated satellite where the stage records include NULL PK(s) and NULL CDK(s)
    Given the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat is already populated with data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | 123       | md5('1004\|\|DOM\|\|17-214-233-1214\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1216\|\|123') | 1993-01-01     | 1993-01-01 | *      |
    And the RAW_STAGE_TWO_CDK table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_PHONE | EXTENSION | LOAD_DATE  | SOURCE |
      | <null>      | <null>        | <null>         | <null>    | 1993-01-02 | *      |
    And I stage the STG_CUSTOMER_TWO_CDK data
    When I load the MULTI_ACTIVE_SATELLITE_TWO_CDK ma_sat
    Then the MULTI_ACTIVE_SATELLITE_TWO_CDK table should contain expected data
      | CUSTOMER_PK | CUSTOMER_NAME | CUSTOMER_PHONE  | EXTENSION | HASHDIFF                                       | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1004') | Dom           | 17-214-233-1214 | 123       | md5('1004\|\|DOM\|\|17-214-233-1214\|\|123')   | 1993-01-01     | 1993-01-01 | *      |
      | md5('1006') | Frida         | 17-214-233-1216 | 123       | md5('1006\|\|FRIDA\|\|17-214-233-1216\|\|123') | 1993-01-01     | 1993-01-01 | *      |
