Feature: We can backup MySQL databases
  As a careful developer I want to regularly backup MySQL databases

  Scenario: End-to-end test using a real database
    Given the database backup_test exists
    When I successfully run `db_backup --force -u root backup_test`
    Then the backup file should be gzipped

  Scenario: End-to-end test using a real database, skipping gzip
    Given the database backup_test exists
    When I successfully run `db_backup --force -u root --no-gzip backup_test`
    Then the backup file should NOT be gzipped
