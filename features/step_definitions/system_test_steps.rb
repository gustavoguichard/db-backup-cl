# frozen_string_literal: true
require 'open3'

MYSQL = ENV['DB_BACKUP_MYSQL'] || '/usr/local/bin/mysql'
USER = ENV['DB_BACKUP_USER'] || 'root'

def expected_filename
  now = Time.now
  format('backup_test%4d%02d%02d.sql', now.year, now.month, now.day)
end

Given(/^the database backup_test exists$/) do
  test_sql_file = File.join(File.expand_path('../..', File.dirname(__FILE__)), 'setup_test.sql')
  command = "#{MYSQL} -u#{USER} < #{test_sql_file}"
  _, err, status = Open3.capture3(command)
  raise "Problem running #{command}, stderr was:\n#{err}" unless status.success?
end

Then(/^the backup file should be gzipped$/) do
  step %(a file named "#{expected_filename}.gz" should exist)
end

Then(/^the backup file should NOT be gzipped$/) do
  step %(a file named "#{expected_filename}" should exist)
end
