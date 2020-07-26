#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'English'

def run_command(command, status = 1)
  system(command)
  return if $CHILD_STATUS.exitstatus.zero?

  puts "There was a problem running '#{command}'"
  exit status
end

options = {}
option_parser = OptionParser.new do |opts|
  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = "Backup one or more MySQL databases

Usage: #{executable_name} [options] database_name

"

  opts.on('-i', '--iteration', 'Indicate that this backup is an "iteration" backup') do
    options[:iteration] = true
  end

  opts.on('-u USER', '--user', /^.+\..+$/, 'Database username, in first.last format') do |user|
    options[:user] = user
  end

  opts.on('-p PASSWORD', '--password', 'Database password') do |password|
    options[:password] = password
  end
end

option_parser.parse! # removes the options and keeps other ARGV

if ARGV.empty?
  puts "error: you must supply a database_name\n\n"
  puts option_parser.help
  exit 3
end

database = ARGV.shift
backup_file = "#{database + Time.now.strftime('%Y%m%d')}.sql"

auth = ''
auth += "-u#{options[:user]} " if options[:user]
auth += "-p#{options[:password]} " if options[:password]

run_command "mysqldump #{auth}#{database} > #{backup_file}"
run_command "gzip #{backup_file}", 2
