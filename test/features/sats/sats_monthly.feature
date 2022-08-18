Feature: [SAT-PM-M] Satellites Loaded using Period Materialization with monthly interval

  @fixture.satellite_cycle
  Scenario: [SAT-PM-M-01] Satellite load over several monthly cycles with insert_by_period into
  empty satellite and an inferred date range.

    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is empty
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 1991-03-21   | 17-214-233-1217 | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 1990-02-03   | 17-214-233-1218 | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beah          | 1995-08-07   | 17-214-233-1215 | 2019-06-05     | 2019-06-05 | *      |
      | 1003        | Chris         | 1990-02-03   | 17-214-233-1216 | 2019-06-05     | 2019-06-05 | *      |
      | 1004        | David         | 1992-01-30   | 17-214-233-1219 | 2019-06-05     | 2019-06-05 | *      |
      | 1010        | Jenny         | 1991-03-25   | 17-214-233-1217 | 2019-06-05     | 2019-06-05 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-07-06     | 2019-07-06 | *      |
      | 1003        | Claire        | 1990-02-03   | 17-214-233-1216 | 2019-07-06     | 2019-07-06 | *      |
      | 1005        | Elwyn         | 2001-07-23   | 17-214-233-1220 | 2019-07-06     | 2019-07-06 | *      |
      | 1006        | Freia         | 1960-01-01   | 17-214-233-1221 | 2019-07-06     | 2019-07-06 | *      |
      | 1002        | Beah          | 1995-08-07   | 17-214-233-1215 | 2019-08-07     | 2019-08-07 | *      |
      | 1003        | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-07     | 2019-08-07 | *      |
      | 1007        | Geoff         | 1990-02-03   | 17-214-233-1222 | 2019-08-07     | 2019-08-07 | *      |
      | 1010        | Jenny         | 1991-03-25   | 17-214-233-1217 | 2019-08-07     | 2019-08-07 | *      |
      | 1011        | Karen         | 1978-06-16   | 17-214-233-1223 | 2019-08-07     | 2019-08-07 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by month
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY\|\|17-214-233-1217')   | Jenny         | 1991-03-21   | 17-214-233-1217 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1012') | md5('1990-02-03\|\|1012\|\|ALBERT\|\|17-214-233-1218')  | Albert        | 1990-02-03   | 17-214-233-1218 | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1215')    | Beah          | 1995-08-07   | 17-214-233-1215 | 2019-06-05     | 2019-06-05 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHRIS\|\|17-214-233-1216')   | Chris         | 1990-02-03   | 17-214-233-1216 | 2019-06-05     | 2019-06-05 | *      |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID\|\|17-214-233-1219')   | David         | 1992-01-30   | 17-214-233-1219 | 2019-06-05     | 2019-06-05 | *      |
      | md5('1010') | md5('1991-03-25\|\|1010\|\|JENNY\|\|17-214-233-1217')   | Jenny         | 1991-03-25   | 17-214-233-1217 | 2019-06-05     | 2019-06-05 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-07-06     | 2019-07-06 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CLAIRE\|\|17-214-233-1216')  | Claire        | 1990-02-03   | 17-214-233-1216 | 2019-07-06     | 2019-07-06 | *      |
      | md5('1005') | md5('2001-07-23\|\|1005\|\|ELWYN\|\|17-214-233-1220')   | Elwyn         | 2001-07-23   | 17-214-233-1220 | 2019-07-06     | 2019-07-06 | *      |
      | md5('1006') | md5('1960-01-01\|\|1006\|\|FREIA\|\|17-214-233-1221')   | Freia         | 1960-01-01   | 17-214-233-1221 | 2019-07-06     | 2019-07-06 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH\|\|17-214-233-1215')    | Beah          | 1995-08-07   | 17-214-233-1215 | 2019-08-07     | 2019-08-07 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1990-02-03   | 17-214-233-1216 | 2019-08-07     | 2019-08-07 | *      |
      | md5('1007') | md5('1990-02-03\|\|1007\|\|GEOFF\|\|17-214-233-1222')   | Geoff         | 1990-02-03   | 17-214-233-1222 | 2019-08-07     | 2019-08-07 | *      |
      | md5('1011') | md5('1978-06-16\|\|1011\|\|KAREN\|\|17-214-233-1223')   | Karen         | 1978-06-16   | 17-214-233-1223 | 2019-08-07     | 2019-08-07 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-M-02] Satellite load with monthly interval and intra-batch, same day duplicates.
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-06-04     | 2019-06-04 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-06-04     | 2019-06-04 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by month with date range: 2019-05-01 to 2019-07-01 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
    And I insert by period into the SATELLITE sat by month with date range: 2019-05-01 to 2019-07-01 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-06-04     | 2019-06-04 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-M-03] Satellite load with monthly interval and intra-load, different day duplicates.
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-04     | 2019-05-03 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-05     | 2019-05-03 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-05-06     | 2019-06-05 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-07     | 2019-06-06 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-05-07     | 2019-07-06 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by month with date range: 2019-05-03 to 2019-05-06 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')   | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03     | 2019-05-03 | *      |
    And I insert by period into the SATELLITE sat by month with date range: 2019-05-01 to 2019-07-01 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-05-03     | 2019-05-03 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-06-05     | 2019-06-05 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-06-06     | 2019-06-06 | *      |

  @fixture.satellite_cycle
  Scenario: [SAT-PM-M-04] Satellite load with monthly interval and intra-batch same day and intra-load duplicates
    Given the SATELLITE table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-06-03     | 2019-06-03 | *      |
      | 1002        | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-06-03     | 2019-06-03 | *      |
      | 1003        | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-06-05     | 2019-06-05 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-06-06     | 2019-06-06 | *      |
      | 1004        | David         | 1995-08-10   | 17-214-233-1217 | 2019-07-06     | 2019-07-06 | *      |
    And I stage the STG_CUSTOMER data
    And I insert by period into the SATELLITE sat by month with date range: 2019-05-01 to 2019-07-01 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                               | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214') | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
    And I insert by period into the SATELLITE sat by month with date range: 2019-05-01 to 2019-07-01 and LDTS LOAD_DATE
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                                                | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT\|\|17-214-233-1214')  | Albert        | 1990-02-03   | 17-214-233-1214 | 2019-05-03     | 2019-05-03 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH\|\|17-214-233-1215')    | Beth          | 1995-08-07   | 17-214-233-1215 | 2019-06-03     | 2019-06-03 | *      |
      | md5('1003') | md5('1995-08-03\|\|1003\|\|CHARLEY\|\|17-214-233-1216') | Charley       | 1995-08-03   | 17-214-233-1216 | 2019-06-05     | 2019-06-05 | *      |
      | md5('1004') | md5('1995-08-10\|\|1004\|\|DAVID\|\|17-214-233-1217')   | David         | 1995-08-10   | 17-214-233-1217 | 2019-06-06     | 2019-06-06 | *      |

