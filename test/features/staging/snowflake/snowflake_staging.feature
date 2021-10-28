Feature: [SF-STG] Staging

  @fixture.staging
  Scenario: [SF-STG-01] Staging with derived, hashed, ranked and source columns.
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
  Scenario: [SF-STG-02] Staging with derived, hashed and source columns.
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
  Scenario: [SF-STG-03] Staging with hashed, ranked and source columns.
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
  Scenario: [SF-STG-04] Staging with hashed and ranked columns
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
  Scenario: [SF-STG-05] Staging with derived, ranked and source columns.
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
  Scenario: [SF-STG-06] Staging where some derived columns are composite values
    Given the STG_CUSTOMER table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1001        | Alice         | 1997-04-24   | 17-214-233-1214 | 1993-01-01 | *      |
      | 1002        | Bob           | 2006-04-17   | 17-214-233-1215 | 1993-01-01 | *      |
      | 1003        | Chad          | 2013-02-04   | 17-214-233-1216 | 1993-01-01 | *      |
      | 1004        | Dom           | 2018-04-13   | 17-214-233-1217 | 1993-01-01 | *      |
    And I have derived columns in the STG_CUSTOMER model
      | CUSTOMER_NK                               | EFFECTIVE_FROM | SOURCE     |
      | [CUSTOMER_NAME, CUSTOMER_DOB, !RAW_STAGE] | LOAD_DATE      | !RAW_STAGE |
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

  @fixture.staging
  Scenario: [SF-STG-07] Staging where a derived column is used as a component in the hashdiff
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

  @fixture.staging
  Scenario: [SF-STG-08] Staging with only source and hashed columns
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
  Scenario: [SF-STG-09] Staging with only source and derived columns
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

  @fixture.staging
  Scenario: [SF-STG-010] Staging with no source columns and derived column as part of a hashdiff
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

  @fixture.staging
  Scenario: [SF-STG-011] Staging for only derived columns
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
  Scenario: [SF-STG-012] Staging for only hashed columns
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
  Scenario: [SF-STG-013] Staging for only ranked columns
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
  Scenario: [SF-STG-014] Staging with derived, source columns and hashed with exclude flag.
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
  Scenario: [SF-STG-015] Staging with only source columns and hashed columns with exclude flag
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

  @fixture.staging
  Scenario: [SF-STG-016] Staging with derived, source columns and hashed when a derived column transforms a source column.
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

  @fixture.staging
  Scenario: [SF-STG-017] Staging with derived, source columns and hashed when a derived column overrides a source column.
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

  @fixture.staging
  Scenario: [SF-STG-018] Staging with derived, source columns and hashed when a hashed column overrides a source column.
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

  @fixture.staging
  Scenario: [SF-STG-019] Staging with derived, source columns and hashed when a derived and a hashed column overrides a source column.
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
