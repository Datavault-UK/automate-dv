Feature: [SF-SAT-OOS-CYC] Out of Sequence Satellites retain base functionality with cycles

  @fixture.satellite_cycle
  Scenario: [SF-SAT-OOS-CYC-01] Satellite load over several cycles
    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is empty

    # ================ DAY 1 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 1995-08-07   | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 1991-03-21   | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 2 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 1995-08-07   | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         | 1990-02-03   | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         | 1991-03-25   | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 3 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 1990-02-03   | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 2001-07-23   | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 1960-01-01   | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 4 ===================
    When the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 1995-08-07   | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | 1010        | Jenny         | 1991-03-25   | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 1978-06-16   | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # =============== CHECKS ===================
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                             | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | md5('1001') | md5('1990-02-03\|\|1001\|\|ALBERT')  | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH')    | Beth          | 1995-08-07   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH')    | Beah          | 1995-08-07   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BETH')    | Beth          | 1995-08-07   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1002') | md5('1995-08-07\|\|1002\|\|BEAH')    | Beah          | 1995-08-07   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY') | Charley       | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHRIS')   | Chris         | 1990-02-03   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CLAIRE')  | Claire        | 1990-02-03   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1003') | md5('1990-02-03\|\|1003\|\|CHARLEY') | Charley       | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1004') | md5('1992-01-30\|\|1004\|\|DAVID')   | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1005') | md5('2001-07-23\|\|1005\|\|ELWYN')   | Elwyn         | 2001-07-23   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1006') | md5('1960-01-01\|\|1006\|\|FREIA')   | Freia         | 1960-01-01   | 2019-05-06     | 2019-05-06 | *      |
      | md5('1007') | md5('1990-02-03\|\|1007\|\|GEOFF')   | Geoff         | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1010') | md5('1991-03-21\|\|1010\|\|JENNY')   | Jenny         | 1991-03-21   | 2019-05-04     | 2019-05-04 | *      |
      | md5('1010') | md5('1991-03-25\|\|1010\|\|JENNY')   | Jenny         | 1991-03-25   | 2019-05-05     | 2019-05-05 | *      |
      | md5('1011') | md5('1978-06-16\|\|1011\|\|KAREN')   | Karen         | 1978-06-16   | 2019-05-07     | 2019-05-07 | *      |
      | md5('1012') | md5('1990-02-03\|\|1012\|\|ALBERT')  | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |

  @fixture.satellite_cycle
  @fixture.enable_sha
  Scenario: [SF-SAT-OOS-CYC-02] Satellite load over several cycles
    Given the RAW_STAGE stage is empty
    And the SATELLITE sat is empty

    # ================ DAY 1 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1001        | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | 1002        | Beth          | 1995-08-07   | 2019-05-04     | 2019-05-04 | *      |
      | 1003        | Charley       | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | 1010        | Jenny         | 1991-03-21   | 2019-05-04     | 2019-05-04 | *      |
      | 1012        | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 2 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 1995-08-07   | 2019-05-05     | 2019-05-05 | *      |
      | 1003        | Chris         | 1990-02-03   | 2019-05-05     | 2019-05-05 | *      |
      | 1004        | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 | *      |
      | 1010        | Jenny         | 1991-03-25   | 2019-05-05     | 2019-05-05 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 3 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beth          | 1995-08-07   | 2019-05-06     | 2019-05-06 | *      |
      | 1003        | Claire        | 1990-02-03   | 2019-05-06     | 2019-05-06 | *      |
      | 1005        | Elwyn         | 2001-07-23   | 2019-05-06     | 2019-05-06 | *      |
      | 1006        | Freia         | 1960-01-01   | 2019-05-06     | 2019-05-06 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # ================ DAY 4 ===================
    And the RAW_STAGE is loaded
      | CUSTOMER_ID | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | 1002        | Beah          | 1995-08-07   | 2019-05-07     | 2019-05-07 | *      |
      | 1003        | Charley       | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | 1007        | Geoff         | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | 1010        | Jenny         | 1991-03-25   | 2019-05-07     | 2019-05-07 | *      |
      | 1011        | Karen         | 1978-06-16   | 2019-05-07     | 2019-05-07 | *      |
    And I stage the STG_CUSTOMER data
    And I load the SATELLITE sat

    # =============== CHECKS ===================
    Then the SATELLITE table should contain expected data
      | CUSTOMER_PK | HASHDIFF                             | CUSTOMER_NAME | CUSTOMER_DOB | EFFECTIVE_FROM | LOAD_DATE  | SOURCE |
      | sha('1001') | sha('1990-02-03\|\|1001\|\|ALBERT')  | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1002') | sha('1995-08-07\|\|1002\|\|BETH')    | Beth          | 1995-08-07   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1002') | sha('1995-08-07\|\|1002\|\|BEAH')    | Beah          | 1995-08-07   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1002') | sha('1995-08-07\|\|1002\|\|BETH')    | Beth          | 1995-08-07   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1002') | sha('1995-08-07\|\|1002\|\|BEAH')    | Beah          | 1995-08-07   | 2019-05-07     | 2019-05-07 | *      |
      | sha('1003') | sha('1990-02-03\|\|1003\|\|CHARLEY') | Charley       | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1003') | sha('1990-02-03\|\|1003\|\|CHRIS')   | Chris         | 1990-02-03   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1003') | sha('1990-02-03\|\|1003\|\|CLAIRE')  | Claire        | 1990-02-03   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1003') | sha('1990-02-03\|\|1003\|\|CHARLEY') | Charley       | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | sha('1004') | sha('1992-01-30\|\|1004\|\|DAVID')   | David         | 1992-01-30   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1005') | sha('2001-07-23\|\|1005\|\|ELWYN')   | Elwyn         | 2001-07-23   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1006') | sha('1960-01-01\|\|1006\|\|FREIA')   | Freia         | 1960-01-01   | 2019-05-06     | 2019-05-06 | *      |
      | sha('1007') | sha('1990-02-03\|\|1007\|\|GEOFF')   | Geoff         | 1990-02-03   | 2019-05-07     | 2019-05-07 | *      |
      | sha('1010') | sha('1991-03-21\|\|1010\|\|JENNY')   | Jenny         | 1991-03-21   | 2019-05-04     | 2019-05-04 | *      |
      | sha('1010') | sha('1991-03-25\|\|1010\|\|JENNY')   | Jenny         | 1991-03-25   | 2019-05-05     | 2019-05-05 | *      |
      | sha('1011') | sha('1978-06-16\|\|1011\|\|KAREN')   | Karen         | 1978-06-16   | 2019-05-07     | 2019-05-07 | *      |
      | sha('1012') | sha('1990-02-03\|\|1012\|\|ALBERT')  | Albert        | 1990-02-03   | 2019-05-04     | 2019-05-04 | *      |