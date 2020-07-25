#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

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
  puts 'error: you must supply a database_name'
  puts
  puts option_parser.help
else
  database = ARGV.shift
  # end_of_iter = ARGV.shift
  # if end_of_iter.nil?
  backup_file = database + Time.now.strftime('%Y%m%d')
  # else
  #   backup_file = database + end_of_iter
  # end
  `mysqldump -u#{options[:user]} -p#{options[:password]} #{database} > #{backup_file}.sql`
  `gzip #{backup_file}.sql`
end
