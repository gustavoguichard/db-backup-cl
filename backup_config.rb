# frozen_string_literal: true

require 'optparse'

class BackupConfig
  attr_reader :options

  def initialize
    @options = { gzip: true }
    option_parser.parse!
    pick_database
  end

  def pick_database
    if ARGV.empty?
      puts "error: you must supply a database_name\n\n"
      puts option_parser.help
      exit 3
    end

    @options[:database] = ARGV.shift
  end

  def option_parser
    @option_parser ||= OptionParser.new do |opts|
      opts.banner = opts_banner

      opts.on('-u USER', '--username', /^.+\..+$/, 'Database username, in first.last format') do |user|
        @options[:user] = user
      end

      opts.on('-p PASSWORD', '--password', 'Database password') do |password|
        @options[:password] = password
      end

      opts.on('-i', '--end-of-iteration', 'Indicate that this backup is an "iteration" backup') do
        @options[:iteration] = true
      end

      opts.on('--[no-]force', 'Overwrite existing backups') do |force|
        @options[:force] = force
      end

      opts.on('--no-gzip', 'Do not compress the backup file') do
        @options[:gzip] = false
      end
    end
  end

  def opts_banner
    executable_name = File.basename($PROGRAM_NAME)
    "Backup one or more MySQL databases

Usage: #{executable_name} [options] database_name

"
  end
end
