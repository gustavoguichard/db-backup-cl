#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'English'
require 'open3'

def run_command(command, statuscode = 1)
  puts "Running '#{command}'"
  _stdout_str, stderr_str, status = Open3.capture3(command)
  return if status.exitstatus.zero?

  $stderr.puts "There was a problem running '#{command}'"
  $stderr.puts stderr_str
  exit statuscode
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
