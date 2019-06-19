@cleanup
Feature: Log files are date-timestamped
  Logging wrapper to record progress and status of the program at runtime

Scenario: The log file is datetime stamped
    When I run the vaultLoader with command line arguments
    Then there will be a logfile
    And the logfile name will start with 'vaultLoader-'
    And the logfile name will end with a datetime stamp formatted as d-m-Y_I:M:S
    And the logfile name will be of type .log

Scenario: There is a permission error accessing the logging directory
    When I run the vaultLoader with a protected logging directory
    Then there will be an error saying that permission is denied.

Scenario: The logging directory doesn't exist
    When I run the vaultLoader with a non-existent logging directory
    Then there will be an error saying that the directory is inaccessible.