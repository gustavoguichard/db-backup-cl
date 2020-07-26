#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'English'
require 'open3'

def run_command(command, statuscode = 1)
  puts "Running '#{command}'"

  yield if block_given?

  _stdout_str, stderr_str, status = Open3.capture3(command)
  return if status.exitstatus.zero?

  warn "There was a problem running '#{command}'"
  warn stderr_str
  exit statuscode
end

options = {
  gzip: true
}

option_parser = OptionParser.new do |opts|
  executable_name = File.basename($PROGRAM_NAME)
  opts.banner = "Backup one or more MySQL databases

Usage: #{executable_name} [options] database_name

"

  opts.on('-u USER', '--username', /^.+\..+$/, 'Database username, in first.last format') do |user|
    options[:user] = user
  end

  opts.on('-p PASSWORD', '--password', 'Database password') do |password|
    options[:password] = password
  end

  opts.on('-i', '--end-of-iteration', 'Indicate that this backup is an "iteration" backup') do
    options[:iteration] = true
  end

  opts.on('--no-gzip', 'Do not compress the backup file') do
    options[:gzip] = false
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

Signal.trap('SIGINT') do
  FileUtils.rm backup_file
  exit 1
end

run_command("mysqldump #{auth}#{database} > #{backup_file}")
run_command("gzip #{backup_file}", 2) if options[:gzip]
