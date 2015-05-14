Feature: Running MissingText
  In order to detect if we are missing any translated language
  As a CLI
  I want to see if the task runs successfully

  Scenario: Running MissingText
    When I run `missing_text rummage`
    Then the output should contain "Finished!"