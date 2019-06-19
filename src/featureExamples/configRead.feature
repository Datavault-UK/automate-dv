Feature: Config file is read.
  Config file is read from a .ini file and the loading of the file is logged.
  Config file is locally and via command line arguments, and laoding errors are checked for.

  @cleanup
  Scenario: The config.ini file is provided from a custom path.
    When I run the vaultLoader with command line arguments
    Then there will be a logfile
    And the logfile will contain 'Config file loaded successfully'.
    And the logfile will contain version information

  @cleanup
  Scenario: The config.ini file is read locally.
    When I run the vaultLoader without command line arguments
    Then there will be a logfile
    And the logfile will contain 'Config file loaded successfully'.
    And the logfile will contain version information

  @cleanup
  Scenario: The program runs with an invalid config file argument.
    When I run the vaultLoader with an invalid file path via the command line.
    Then there will be a log message with a config load error.

  @cleanup
  Scenario: The program runs without a local config or command line argument.
    When I run the vaultLoader without a local config file or command line argument.
    Then there will be a log message with a config load error.