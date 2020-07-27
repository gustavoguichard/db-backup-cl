# frozen_string_literal: true

require 'optparse'
require 'yaml'

module DbBackup
  class Config
    attr_reader :options

    def initialize
      read_default_options
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

    private

    def read_default_options
      @options ||= {
        gzip: true,
        force: false,
        'end-of-iteration': false,
        username: nil,
        password: nil
      }
      File.exist?(config_file) ? merge_default_config : create_default_config
    end

    def config_file
      File.join(ENV['HOME'], '.db_backup.rc.yaml')
    end

    def merge_default_config
      config = YAML.load_file(config_file)
      @options.merge!(config)
    end

    def create_default_config
      File.open(config_file, 'w') { |file| YAML.dump(@options, file) }
      warn "Initialized configuration file in #{config_file}"
    end

    def option_parser
      @option_parser ||= OptionParser.new do |opts|
        opts.banner = opts_banner

        opts.on('-u USER', '--username', 'Database username') do |user|
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
end
