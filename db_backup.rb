#!/usr/bin/env ruby

require 'optparse'

options = {}
option_parser = OptionParser.new do |opts|

  opts.on('-i', '--iteration') do
    options[:iteration] = true
  end

  opts.on('-u USER', '--user', /^.+\..+$/) do |user|
    options[:user] = user
  end

  opts.on('-p PASSWORD', '--password') do |password|
    options[:password] = password
  end

end

option_parser.parse!
puts options.inspect

# database = ARGV.shift
# username = ARGV.shift
# password = ARGV.shift
# end_of_iter = ARGV.shift

# if end_of_iter.nil?
#   backup_file = database + Time.now.strftime("%Y%m%d")
# else
#   backup_file = database + end_of_iter
# end

# `mysqldump -u#{username} -p#{password} #{database} > #{backup_file}.sql` `gzip #{backup_file}.sql`
