Feature: [STG] Staging

  @fixture.staging
  Scenario: [STG-01] Staging with derived, hashed, ranked and source columns.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | DBTVAULT_RANK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 1             |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 1             |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 1             |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 1             |

  @fixture.staging
  Scenario: [STG-02] Staging with derived, hashed and source columns.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @fixture.staging
  Scenario: [STG-03] Staging with hashed, ranked and source columns.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE | CUSTOMER_PK | HASHDIFF                                      | DBTVAULT_RANK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1             |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1             |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1             |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1             |

  @fixture.staging
  Scenario: [STG-04] Staging with hashed and ranked columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    And I do not include source columns
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                      | DBTVAULT_RANK |
      | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1             |
      | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1             |
      | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1             |
      | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1             |

  @fixture.staging
  Scenario: [STG-05] Staging with derived, ranked and source columns.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE    | DBTVAULT_RANK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | RAW_STAGE | 1             |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | RAW_STAGE | 1             |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | RAW_STAGE | 1             |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | RAW_STAGE | 1             |

  @fixture.staging
  Scenario: [STG-06] Staging where some derived columns are composite values
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | CUSTOMER_NK                             | EFFECTIVE_FROM | SOURCE     |
      | [CUSTOMER_NAME,CUSTOMER_DOB,!RAW_STAGE] | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | CUSTOMER_NK                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | Alice\|\|1997-04-24\|\|RAW_STAGE | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | Bob\|\|2006-04-17\|\|RAW_STAGE   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | Chad\|\|2013-02-04\|\|RAW_STAGE  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | Dom\|\|2018-04-13\|\|RAW_STAGE   | 1993-01-01     | RAW_STAGE |

  @snowflake
  @fixture.staging
  Scenario: [STG-07-SF] Staging where a derived column is used as a component in the hashdiff
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                              |
      | LOAD_DATE      | !RAW_STAGE | TO_VARCHAR(CUSTOMER_DOB::date, 'DD-MM-YYYY') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @bigquery
  @fixture.staging
  Scenario: [STG-07-BQ] Staging where a derived column is used as a component in the hashdiff
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                                               |
      | LOAD_DATE      | !RAW_STAGE | FORMAT_DATE("%d-%m-%Y", PARSE_DATE("%Y-%m-%d", CUSTOMER_DOB)) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @sqlserver
  @fixture.staging
  Scenario: [STG-07-SQLS] Staging where a derived column is used as a component in the hashdiff
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                                            |
      | LOAD_DATE      | !RAW_STAGE | CONVERT(VARCHAR(10), CONVERT(DATE, CUSTOMER_DOB, 23), 105) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @fixture.staging
  Scenario: [STG-08] Staging with only source and hashed columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | *      |

  @fixture.staging
  Scenario: [STG-09] Staging with only source and derived columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01     | RAW_STAGE |

  @snowflake
  @fixture.staging
  Scenario: [STG-10-SF] Staging with no source columns and derived column as part of a hashdiff
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                              |
      | LOAD_DATE      | !RAW_STAGE | TO_VARCHAR(CUSTOMER_DOB::date, 'DD-MM-YYYY') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    And I do not include source columns
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @bigquery
  @fixture.staging
  Scenario: [STG-10-BQ] Staging with no source columns and derived column as part of a hashdiff
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                                               |
      | LOAD_DATE      | !RAW_STAGE | FORMAT_DATE("%d-%m-%Y", PARSE_DATE("%Y-%m-%d", CUSTOMER_DOB)) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    And I do not include source columns
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @sqlserver
  @fixture.staging
  Scenario: [STG-10-SQLS] Staging with no source columns and derived column as part of a hashdiff
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                                            |
      | LOAD_DATE      | !RAW_STAGE | CONVERT(VARCHAR(10), CONVERT(DATE, CUSTOMER_DOB, 23), 105) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    And I do not include source columns
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @fixture.staging
  Scenario: [STG-11] Staging for only derived columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I do not include source columns
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | EFFECTIVE_FROM | SOURCE    |
      | 1993-01-01     | RAW_STAGE |
      | 1993-01-01     | RAW_STAGE |
      | 1993-01-01     | RAW_STAGE |
      | 1993-01-01     | RAW_STAGE |

  @fixture.staging
  Scenario: [STG-12] Staging for only hashed columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I do not include source columns
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                      |
      | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') |
      | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   |
      | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  |
      | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   |

  @fixture.staging
  Scenario: [STG-13] Staging for only ranked columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    And I do not include source columns
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | DBTVAULT_RANK |
      | 1             |
      | 1             |
      | 1             |
      | 1             |

  @fixture.staging
  Scenario: [STG-14] Staging with derived, source columns and hashed with exclude flag.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                        |
      | CUSTOMER_ID | exclude_hashdiff('CUSTOMER_ID,SOURCE,LOAD_DATE,EFFECTIVE_FROM') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @fixture.staging
  Scenario: [STG-15] Staging with only source columns and hashed columns with exclude flag
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                         |
      | CUSTOMER_ID | exclude_hashdiff('CUSTOMER_ID,LOAD_DATE,SOURCE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | *      |

  @snowflake
  @fixture.staging
  Scenario: [STG-16-SF] Staging with derived, source columns and hashed when a derived column transforms a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                              |
      | LOAD_DATE      | !RAW_STAGE | TO_VARCHAR(CUSTOMER_DOB::date, 'DD-MM-YYYY') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @bigquery
  @fixture.staging
  Scenario: [STG-16-BQ] Staging with derived, source columns and hashed when a derived column transforms a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                                               |
      | LOAD_DATE      | !RAW_STAGE | FORMAT_DATE("%d-%m-%Y", PARSE_DATE("%Y-%m-%d", CUSTOMER_DOB)) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @sqlserver
  @fixture.staging
  Scenario: [STG-16-SQLS] Staging with derived, source columns and hashed when a derived column transforms a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB_UK                                            |
      | LOAD_DATE      | !RAW_STAGE | CONVERT(VARCHAR(10), CONVERT(DATE, CUSTOMER_DOB, 23), 105) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                 |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB_UK,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | CUSTOMER_DOB_UK |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018      |

  @snowflake
  @fixture.staging
  Scenario: [STG-17-SF] Staging with derived, source columns and hashed when a derived column overrides a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB                                 |
      | LOAD_DATE      | !RAW_STAGE | TO_VARCHAR(CUSTOMER_DOB::date, 'DD-MM-YYYY') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 24-04-1997   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 17-04-2006   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 04-02-2013   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 13-04-2018   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @bigquery
  @fixture.staging
  Scenario: [STG-17-BQ] Staging with derived, source columns and hashed when a derived column overrides a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB                                                  |
      | LOAD_DATE      | !RAW_STAGE | FORMAT_DATE("%d-%m-%Y", PARSE_DATE("%Y-%m-%d", CUSTOMER_DOB)) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 24-04-1997   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 17-04-2006   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 04-02-2013   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 13-04-2018   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @sqlserver
  @fixture.staging
  Scenario: [STG-17-SQLS] Staging with derived, source columns and hashed when a derived column overrides a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB                                               |
      | LOAD_DATE      | !RAW_STAGE | CONVERT(VARCHAR(10), CONVERT(DATE, CUSTOMER_DOB, 23), 105) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 24-04-1997   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 17-04-2006   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 04-02-2013   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 13-04-2018   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @not_sqlserver
  @fixture.staging
  Scenario: [STG-18] Staging with derived, source columns and hashed when a hashed column overrides a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_ID   |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') | CUSTOMER_NAME |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID  | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | md5('ALICE') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | md5('BOB')   | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | md5('CHAD')  | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | md5('DOM')   | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @sqlserver
  @fixture.staging
  Scenario: [STG-18-SQLS] Staging with derived, source columns and hashed when a hashed column overrides a source column.
    Given the STG_CUSTOMER_HASH table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER_HASH model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER_HASH model
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_ID   |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') | CUSTOMER_NAME |
    When I stage the STG_CUSTOMER_HASH data
    Then the STG_CUSTOMER_HASH table should contain expected data
      | CUSTOMER_ID  | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | md5('ALICE') | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | md5('BOB')   | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | md5('CHAD')  | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | md5('DOM')   | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @snowflake
  @fixture.staging
  Scenario: [STG-19-SF] Staging with derived, source columns and hashed when a derived and a hashed column overrides a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB                                 |
      | LOAD_DATE      | !RAW_STAGE | TO_VARCHAR(CUSTOMER_DOB::date, 'DD-MM-YYYY') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_ID   |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') | CUSTOMER_NAME |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID  | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | md5('ALICE') | Alice         | 24-04-1997   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | md5('BOB')   | Bob           | 17-04-2006   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | md5('CHAD')  | Chad          | 04-02-2013   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | md5('DOM')   | Dom           | 13-04-2018   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @bigquery
  @fixture.staging
  Scenario: [STG-19-BQ] Staging with derived, source columns and hashed when a derived and a hashed column overrides a source column.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB                                                  |
      | LOAD_DATE      | !RAW_STAGE | FORMAT_DATE("%d-%m-%Y", PARSE_DATE("%Y-%m-%d", CUSTOMER_DOB)) |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_ID   |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') | CUSTOMER_NAME |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID  | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | md5('ALICE') | Alice         | 24-04-1997   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | md5('BOB')   | Bob           | 17-04-2006   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | md5('CHAD')  | Chad          | 04-02-2013   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | md5('DOM')   | Dom           | 13-04-2018   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @sqlserver
  @fixture.staging
  Scenario: [STG-19-SQLS] Staging with derived, source columns and hashed when a derived and a hashed column overrides a source column.
    Given the STG_CUSTOMER_HASH table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER_HASH model
      | EFFECTIVE_FROM | SOURCE     | CUSTOMER_DOB                                               |
      | LOAD_DATE      | !RAW_STAGE | CONVERT(VARCHAR(10), CONVERT(DATE, CUSTOMER_DOB, 23), 105) |
    And I have hashed columns in the STG_CUSTOMER_HASH model
      | CUSTOMER_PK | HASHDIFF                                              | CUSTOMER_ID   |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') | CUSTOMER_NAME |
    When I stage the STG_CUSTOMER_HASH data
    Then the STG_CUSTOMER_HASH table should contain expected data
      | CUSTOMER_ID  | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | md5('ALICE') | Alice         | 24-04-1997   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('24-04-1997\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | md5('BOB')   | Bob           | 17-04-2006   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('17-04-2006\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | md5('CHAD')  | Chad          | 04-02-2013   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('04-02-2013\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | md5('DOM')   | Dom           | 13-04-2018   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('13-04-2018\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @not_sqlserver
  @fixture.staging
  Scenario: [STG-20] Staging with derived (with concatenation), hashed, ranked (multiple incl. composite) and source columns.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | DERIVED_CONCAT             |
      | LOAD_DATE      | !RAW_STAGE | [!RAW_STAGE,CUSTOMER_NAME] |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME           | PARTITION_BY                | ORDER_BY                 |
      | DBTVAULT_RANK  | CUSTOMER_ID                 | LOAD_DATE                |
      | DBTVAULT_RANK2 | [CUSTOMER_ID,CUSTOMER_NAME] | [LOAD_DATE,CUSTOMER_DOB] |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | DERIVED_CONCAT     | DBTVAULT_RANK | DBTVAULT_RANK2 |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Alice | 1             | 1              |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Bob   | 1             | 1              |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Chad  | 1             | 1              |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Dom   | 1             | 1              |

  @sqlserver
  @fixture.staging
  Scenario: [STG-20-SQLS] Staging with derived (with concatenation), hashed, ranked (multiple incl. composite) and source columns.
    Given the STG_CUSTOMER_CONCAT table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER_CONCAT model
      | EFFECTIVE_FROM | SOURCE     | DERIVED_CONCAT             |
      | LOAD_DATE      | !RAW_STAGE | [!RAW_STAGE,CUSTOMER_NAME] |
    And I have hashed columns in the STG_CUSTOMER_CONCAT model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER_CONCAT model
      | NAME           | PARTITION_BY                | ORDER_BY                 |
      | DBTVAULT_RANK  | CUSTOMER_ID                 | LOAD_DATE                |
      | DBTVAULT_RANK2 | [CUSTOMER_ID,CUSTOMER_NAME] | [LOAD_DATE,CUSTOMER_DOB] |
    When I stage the STG_CUSTOMER_CONCAT data
    Then the STG_CUSTOMER_CONCAT table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | DERIVED_CONCAT     | DBTVAULT_RANK | DBTVAULT_RANK2 |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Alice | 1             | 1              |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Bob   | 1             | 1              |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Chad  | 1             | 1              |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Dom   | 1             | 1              |

  @not_bigquery
  @not_sqlserver
  @fixture.staging_escaped
  Scenario: [STG-21] Staging with derived (with concatenation), hashed, ranked (multiple incl. composite) and source columns.
  The customer name column name in the RAW_STAGE table includes a SPACE character, and there is derived column called COLUMN
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | COLUMN                             | CUSTOMER_NAME           |
      | LOAD_DATE      | !RAW_STAGE | escape('!RAW_STAGE,CUSTOMER NAME') | escape('CUSTOMER NAME') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME           | PARTITION_BY                | ORDER_BY                 |
      | DBTVAULT_RANK  | CUSTOMER_ID                 | LOAD_DATE                |
      | DBTVAULT_RANK2 | [CUSTOMER_ID,CUSTOMER_NAME] | [LOAD_DATE,CUSTOMER_DOB] |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | COLUMN             | DBTVAULT_RANK | DBTVAULT_RANK2 |
      | 1001        | Alice         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Alice | 1             | 1              |
      | 1002        | Bob           | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Bob   | 1             | 1              |
      | 1003        | Chad          | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Chad  | 1             | 1              |
      | 1004        | Dom           | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Dom   | 1             | 1              |

  @sqlserver
  @fixture.staging_escaped
  Scenario: [STG-21-SQLS] Staging with derived (with concatenation), hashed, ranked (multiple incl. composite) and source columns.
  The customer name column name in the RAW_STAGE table includes a SPACE character
    Given the STG_CUSTOMER_NAME table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER_NAME model
      | EFFECTIVE_FROM | SOURCE     | DERIVED_CONCAT                     | CUSTOMER_NAME           |
      | LOAD_DATE      | !RAW_STAGE | escape('!RAW_STAGE,CUSTOMER NAME') | escape('CUSTOMER NAME') |
    And I have hashed columns in the STG_CUSTOMER_NAME model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER_NAME model
      | NAME           | PARTITION_BY                | ORDER_BY                 |
      | DBTVAULT_RANK  | CUSTOMER_ID                 | LOAD_DATE                |
      | DBTVAULT_RANK2 | [CUSTOMER_ID,CUSTOMER_NAME] | [LOAD_DATE,CUSTOMER_DOB] |
    When I stage the STG_CUSTOMER_NAME data
    Then the STG_CUSTOMER_NAME table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | DERIVED_CONCAT     | DBTVAULT_RANK | DBTVAULT_RANK2 |
      | 1001        | Alice         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Alice | 1             | 1              |
      | 1002        | Bob           | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Bob   | 1             | 1              |
      | 1003        | Chad          | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Chad  | 1             | 1              |
      | 1004        | Dom           | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | RAW_STAGE\|\|Dom   | 1             | 1              |

  @fixture.staging
  Scenario: [STG-22] Staging with derived, source columns and hashed with exclude flag, where exclude columns are lowercase.
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                                        |
      | CUSTOMER_ID | exclude_hashdiff('customer_id,source,load_date,effective_from') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE |

  @not_bigquery
  @not_sqlserver
  @fixture.staging_escaped
  Scenario: [STG-23] Staging with derived (with concatenation), hashed, ranked (multiple incl. composite) and source columns.
  The customer flag column name in the RAW_STAGE table includes a SPACE character, and there are a variety of derived columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER FLAG | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1             | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 0             | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 1             | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 0             | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | COLUMN              | CUSTOMER_NAME           |
      | LOAD_DATE      | !RAW_STAGE | NOT "CUSTOMER FLAG" | escape('CUSTOMER NAME') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME           | PARTITION_BY                | ORDER_BY                 |
      | DBTVAULT_RANK  | CUSTOMER_ID                 | LOAD_DATE                |
      | DBTVAULT_RANK2 | [CUSTOMER_ID,CUSTOMER_NAME] | [LOAD_DATE,CUSTOMER_DOB] |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER_NAME | CUSTOMER FLAG | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | COLUMN | DBTVAULT_RANK | DBTVAULT_RANK2 |
      | 1001        | Alice         | Alice         | 1             | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | false  | 1             | 1              |
      | 1002        | Bob           | Bob           | 0             | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | true   | 1             | 1              |
      | 1003        | Chad          | Chad          | 1             | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | false  | 1             | 1              |
      | 1004        | Dom           | Dom           | 0             | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | true   | 1             | 1              |

  @not_bigquery
  @not_sqlserver
  @fixture.staging_escaped
  Scenario: [STG-24] Staging with derived (with concatenation), hashed, ranked (multiple incl. composite) and source columns.
  The customer dob column name in the RAW_STAGE table includes a SPACE character, and there are a variety of derived columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     | COLUMN                                         | CUSTOMER_NAME           | CUSTOMER_DOB           |
      | LOAD_DATE      | !RAW_STAGE | TO_VARCHAR("CUSTOMER DOB"::date, 'DD-MM-YYYY') | escape('CUSTOMER NAME') | escape('CUSTOMER DOB') |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME           | PARTITION_BY                | ORDER_BY                 |
      | DBTVAULT_RANK  | CUSTOMER_ID                 | LOAD_DATE                |
      | DBTVAULT_RANK2 | [CUSTOMER_ID,CUSTOMER_NAME] | [LOAD_DATE,CUSTOMER_DOB] |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER_NAME | CUSTOMER DOB | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | COLUMN      | DBTVAULT_RANK | DBTVAULT_RANK2 |
      | 1001        | Alice         | Alice         | 1997-04-24   | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997  | 1             | 1              |
      | 1002        | Bob           | Bob           | 2006-04-17   | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006  | 1             | 1              |
      | 1003        | Chad          | Chad          | 2013-02-04   | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013  | 1             | 1              |
      | 1004        | Dom           | Dom           | 2018-04-13   | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018  | 1             | 1              |

  @sqlserver
  @fixture.staging_escaped
  Scenario: [STG-24-SQLS] Staging with derived (with concatenation), hashed, ranked (multiple incl. composite) and source columns.
  The customer dob column name in the RAW_STAGE table includes a SPACE character, and there are a variety of derived columns
    Given the STG_CUSTOMER_NAME_DOB table does not exist
    And the RAW_STAGE_NAME_DOB table contains data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER_NAME_DOB model
      | EFFECTIVE_FROM | SOURCE     | COLUMN                                | CUSTOMER_NAME           | CUSTOMER_DOB           |
      | LOAD_DATE      | !RAW_STAGE | CONVERT(varchar, CAST("CUSTOMER DOB" AS datetime), 105) | escape('CUSTOMER NAME') | escape('CUSTOMER DOB') |
    And I have hashed columns in the STG_CUSTOMER_NAME_DOB model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER_NAME_DOB model
      | NAME           | PARTITION_BY                | ORDER_BY                 |
      | DBTVAULT_RANK  | CUSTOMER_ID                 | LOAD_DATE                |
      | DBTVAULT_RANK2 | [CUSTOMER_ID,CUSTOMER_NAME] | [LOAD_DATE,CUSTOMER_DOB] |
    When I stage the STG_CUSTOMER_NAME_DOB data
    Then the STG_CUSTOMER_NAME_DOB table should contain expected data
      | CUSTOMER_ID | CUSTOMER NAME | CUSTOMER_NAME | CUSTOMER DOB | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | CUSTOMER_PK | HASHDIFF                                      | EFFECTIVE_FROM | SOURCE    | COLUMN      | DBTVAULT_RANK | DBTVAULT_RANK2 |
      | 1001        | Alice         | Alice         | 1997-04-24   | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | md5('1001') | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1993-01-01     | RAW_STAGE | 24-04-1997  | 1             | 1              |
      | 1002        | Bob           | Bob           | 2006-04-17   | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | md5('1002') | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1993-01-01     | RAW_STAGE | 17-04-2006  | 1             | 1              |
      | 1003        | Chad          | Chad          | 2013-02-04   | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | md5('1003') | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1993-01-01     | RAW_STAGE | 04-02-2013  | 1             | 1              |
      | 1004        | Dom           | Dom           | 2018-04-13   | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | md5('1004') | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1993-01-01     | RAW_STAGE | 13-04-2018  | 1             | 1              |

  @fixture.staging_null_columns
  Scenario: [STG-25] Staging with null columns configuration where all required keys are null
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL |
      | CUSTOMER_ID |          |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | md5('-1')   | <null>               | -1          | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-26] Staging with null columns configuration where there are two required keys
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | <null>        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | <null>      | <null>        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED                    | OPTIONAL |
      | [CUSTOMER_ID,CUSTOMER_NAME] |          |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    |
      | md5('1001') | 1001                 | 1001        | <null>                 | -1            | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('1002') | 1002                 | 1002        | Bob                    | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                 | -1            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Dom                    | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-27] Staging with null columns configuration where there is a required and optional key
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | 1001        | <null>        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL      |
      | CUSTOMER_ID | CUSTOMER_NAME |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    |
      | md5('1001') | 1001                 | 1001        | <null>                 | -2            | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('1002') | 1002                 | 1002        | Bob                    | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                 | -2            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Dom                    | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-28] Staging with null columns configuration where there is are two optional keys
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | 1001        | Alice         | <null>       | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | 1002        | <null>        | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | 1004        | <null>        | <null>       | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL                     |
      |             | [CUSTOMER_NAME,CUSTOMER_DOB] |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB_ORIGINAL | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    |
      | md5('1001') | 1001        | Alice                  | Alice         | <null>                | -2           | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('1002') | 1002        | <null>                 | -2            | 2006-04-17            | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('1003') | 1003        | Chad                   | Chad          | 2013-02-04            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('1004') | 1004        | <null>                 | -2            | <null>                | -2           | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-29] Staging with null columns configuration where single required key is null
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL |
      | CUSTOMER_ID |          |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | md5('-1')   | <null>               | -1          | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-30] Staging with null columns configuration where two required keys are null
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED                   | OPTIONAL |
      | [CUSTOMER_ID,CUSTOMER_REF] |          |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | md5('-1')   | <null>               | -1          | <null>                | -1           | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                | -1           | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                | -1           | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                | -1           | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-31] Staging with null columns configuration where single optional key is null
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL            |
      |             | CUSTOMER_ID         |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | md5('-2')   | <null>               | -2          | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | md5('-2')   | <null>               | -2          | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | md5('-2')   | <null>               | -2          | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | md5('-2')   | <null>               | -2          | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-32] Staging with null columns configuration where two optional keys are null
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED | OPTIONAL                   |
      |          | [CUSTOMER_ID,CUSTOMER_REF] |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | md5('-2')   | <null>               | -2          | <null>                | -2           | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | md5('-2')   | <null>               | -2          | <null>                | -2           | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | md5('-2')   | <null>               | -2          | <null>                | -2           | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | md5('-2')   | <null>               | -2          | <null>                | -2           | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-33] Staging with null columns configuration with null required and optional keys
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL     |
      | CUSTOMER_ID | CUSTOMER_REF |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | md5('-1')   | <null>               | -1          | <null>                | -2           | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                | -2           | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                | -2           | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>                | -2           | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-34] Staging with null columns configuration with null multiple required and optional keys
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | ORDER_ID | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | <null>   | <null>     | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | <null>   | <null>     | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | <null>   | <null>     | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | <null>   | <null>     | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED               | OPTIONAL                  |
      | [CUSTOMER_ID,ORDER_ID] | [CUSTOMER_REF,ORDER_LINE] |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | ORDER_ID_ORIGINAL | ORDER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | ORDER_LINE_ORIGINAL | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-35] Staging with null columns configuration with null multiple required and optional keys, and derived column
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | ORDER_ID | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | <null>   | <null>     | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED               | OPTIONAL                  |
      | [CUSTOMER_ID,ORDER_ID] | [CUSTOMER_REF,ORDER_LINE] |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | ORDER_ID_ORIGINAL | ORDER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | ORDER_LINE_ORIGINAL | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-36] Staging with null columns configuration with null multiple required and optional keys, and derived and ranked columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | ORDER_ID | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | <null>   | <null>     | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED               | OPTIONAL                  |
      | [CUSTOMER_ID,ORDER_ID] | [CUSTOMER_REF,ORDER_LINE] |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | ORDER_ID_ORIGINAL | ORDER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | ORDER_LINE_ORIGINAL | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    | DBTVAULT_RANK |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE | 1             |

  @fixture.staging_null_columns
  Scenario: [STG-37] Staging with null columns configuration with null multiple required and optional keys, and ranked columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | ORDER_ID | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | <null>   | <null>     | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED               | OPTIONAL                  |
      | [CUSTOMER_ID,ORDER_ID] | [CUSTOMER_REF,ORDER_LINE] |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK |
      | CUSTOMER_ID |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | ORDER_ID_ORIGINAL | ORDER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | ORDER_LINE_ORIGINAL | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    | DBTVAULT_RANK |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         | 1             |

  @fixture.staging_null_columns
  Scenario: [STG-38] Staging with null columns configuration with null multiple required and optional keys, and derived, hashdiff and ranked columns
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | ORDER_ID | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | <null>   | <null>     | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | <null>       | <null>   | <null>     | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED               | OPTIONAL                  |
      | [CUSTOMER_ID,ORDER_ID] | [CUSTOMER_REF,ORDER_LINE] |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    And I have ranked columns in the STG_CUSTOMER model
      | NAME          | PARTITION_BY | ORDER_BY  |
      | DBTVAULT_RANK | CUSTOMER_ID  | LOAD_DATE |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | ORDER_ID_ORIGINAL | ORDER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | ORDER_LINE_ORIGINAL | ORDER_LINE | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    | HASHDIFF                                      | DBTVAULT_RANK |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('1997-04-24\|\|ALICE\|\|17-214-233-1214') | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('2006-04-17\|\|BOB\|\|17-214-233-1215')   | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('2013-02-04\|\|CHAD\|\|17-214-233-1216')  | 1             |
      | md5('-1')   | <null>               | -1          | <null>            | -1       | <null>                | -2           | <null>              | -2         | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('2018-04-13\|\|DOM\|\|17-214-233-1217')   | 1             |

  @fixture.staging_null_columns
  Scenario: [STG-39] Staging with null columns configuration where single required key is null, no hashed column
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>      | <null>       | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL     |
      | CUSTOMER_ID | CUSTOMER_REF |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>               | -1          | <null>                | -2           | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | RAW_STAGE |
      | <null>               | -1          | <null>                | -2           | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | RAW_STAGE |
      | <null>               | -1          | <null>                | -2           | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | RAW_STAGE |
      | <null>               | -1          | <null>                | -2           | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | RAW_STAGE |

  @fixture.staging_null_columns
  Scenario: [STG-40] Staging with null columns configuration where single required key is null, no hashed column and a derived column
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | <null>      | <null>       | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | <null>      | <null>       | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>       | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | <null>       | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL     |
      | CUSTOMER_ID | CUSTOMER_REF |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_REF_ORIGINAL | CUSTOMER_REF | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    |
      | <null>               | -1          | <null>                | -2           | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | <null>               | -1          | <null>                | -2           | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | <null>               | -1          | <null>                | -2           | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE |
      | <null>               | -1          | <null>                | -2           | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE |

  @fixture.staging_null_columns
  @fixture.enable_sha
  Scenario: [STG-41] Staging with null columns configuration where there is a required and optional key, using SHA256 hash algorithm
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | 1001        | <null>        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have null columns in the STG_CUSTOMER model
      | REQUIRED    | OPTIONAL      |
      | CUSTOMER_ID | CUSTOMER_NAME |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    | HASHDIFF                                    |
      | sha('1001') | 1001                 | 1001        | <null>                 | -2            | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('1997-04-24\|\|-2\|\|17-214-233-1214')  |
      | sha('1002') | 1002                 | 1002        | Bob                    | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('2006-04-17\|\|BOB\|\|17-214-233-1215') |
      | sha('-1')   | <null>               | -1          | <null>                 | -2            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('2013-02-04\|\|-2\|\|17-214-233-1216')  |
      | sha('-1')   | <null>               | -1          | Dom                    | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('2018-04-13\|\|DOM\|\|17-214-233-1217') |

  @fixture.staging_null_columns
  Scenario: [STG-42] Staging with null columns configuration where there is a required and optional key using custom null key values
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | -1          | <null>        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | -2          | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have null columns in the STG_CUSTOMER model and null_key_required is -6 and null_key_optional is -9
      | REQUIRED    | OPTIONAL      |
      | CUSTOMER_ID | CUSTOMER_NAME |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    | HASHDIFF                                    |
      | md5('-1')   | -1                   | -1          | <null>                 | -9            | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('1997-04-24\|\|-9\|\|17-214-233-1214')  |
      | md5('-2')   | -2                   | -2          | Bob                    | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('2006-04-17\|\|BOB\|\|17-214-233-1215') |
      | md5('-6')   | <null>               | -6          | <null>                 | -9            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('2013-02-04\|\|-9\|\|17-214-233-1216')  |
      | md5('-6')   | <null>               | -6          | Dom                    | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE | md5('2018-04-13\|\|DOM\|\|17-214-233-1217') |

  @fixture.staging_null_columns
  @fixture.enable_sha
  Scenario: [STG-43] Staging with null columns configuration where there is a required and optional key, using SHA256 hash algorithm and custom null key values
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE    |
      | -1          | <null>        | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *         |
      | -2          | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *         |
      | <null>      | <null>        | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *         |
      | <null>      | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *         |
    And I have null columns in the STG_CUSTOMER model and null_key_required is -6 and null_key_optional is -9
      | REQUIRED    | OPTIONAL      |
      | CUSTOMER_ID | CUSTOMER_NAME |
    And I have derived columns in the STG_CUSTOMER model
      | EFFECTIVE_FROM | SOURCE     |
      | LOAD_DATE      | !RAW_STAGE |
    And I have hashed columns in the STG_CUSTOMER model
      | CUSTOMER_PK | HASHDIFF                                              |
      | CUSTOMER_ID | hashdiff('CUSTOMER_NAME,CUSTOMER_DOB,CUSTOMER_PHONE') |
    When I stage the STG_CUSTOMER data
    Then the STG_CUSTOMER table should contain expected data
      | CUSTOMER_PK | CUSTOMER_ID_ORIGINAL | CUSTOMER_ID | CUSTOMER_NAME_ORIGINAL | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | EFFECTIVE_FROM  | SOURCE    | HASHDIFF                                    |
      | sha('-1')   | -1                   | -1          | <null>                 | -9            | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('1997-04-24\|\|-9\|\|17-214-233-1214')  |
      | sha('-2')   | -2                   | -2          | Bob                    | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('2006-04-17\|\|BOB\|\|17-214-233-1215') |
      | sha('-6')   | <null>               | -6          | <null>                 | -9            | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('2013-02-04\|\|-9\|\|17-214-233-1216')  |
      | sha('-6')   | <null>               | -6          | Dom                    | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | 1993-01-01      | RAW_STAGE | sha('2018-04-13\|\|DOM\|\|17-214-233-1217') |

