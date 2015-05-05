Feature: Running LocaleDiff
  In order to detect if we are missing any translated language
  As a CLI
  I want to see if the task runs successfully

  Scenario: Running LocaleDiff
    When I run `locale_diff rummage`
    Then the output should contain "Finished!"