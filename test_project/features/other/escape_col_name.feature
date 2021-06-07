@fixture.set_workdir
Feature: Escape Column Name
  Wrapping all the column names of a data vault feature in double quotes ("")

  @fixture.satellite
  Scenario: [ESC-COL-NAME-SAT] Checking the escaping column name macro on the satellite
    Given the SATELLITE_ESCAPED table does not exist
    And the RAW_STAGE_ESCAPED table contains data
      | PK | 'COLUMN' | 'COLUMN 2' | COLUMN_3  | _COLUMN4  | COLUMN5_  | 'COL6' | 'COLUMN 7' | DATE       | SOURCE |
      | A  | B        | C          | D         | E         | F         | G      | H          | 2020-01-01 | *      |
    And I create the STG_ESCAPED stage
    When I load the SATELLITE_ESCAPED sat
    Then the SATELLITE_ESCAPED table should contain expected data
      | TABLE_PK | HASHDIFF                               | "'COLUMN'" | "'COLUMN 2'" | "COLUMN_3" | "_COLUMN4" | "COLUMN5_" | "'COL6'" | "'COLUMN 7'" | "'EFFECTIVE-FROM'" | DATE       | "SOURCE" |
      | md5('A') | md5('B\|\|C\|\|D\|\|E\|\|F\|\|G\|\|H') | B          | C            | D          | E          | F          | G        | H            | 2020-01-01       | 2020-01-01 | *        |
