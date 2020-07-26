# frozen_string_literal: true

require 'open3'
require './backup_config.rb'

class BackupManager
  attr_reader :options

  def initialize(options)
    @options = options

    yield self if block_given?
  end

  def database
    options[:database]
  end

  def backup_file
    @backup_file ||= "#{database + Time.now.strftime('%Y%m%d')}.sql"
  end

  def auth_string
    auth = ''
    auth += "-u#{options[:user]} " if options[:user]
    auth += "-p#{options[:password]} " if options[:password]
    auth
  end

  def backup!
    run_command("mysqldump #{auth_string}#{database} > #{backup_file}") do
      prevent_broken_backup
      prevent_overwrite
    end
  end

  def gzip!
    run_command("gzip #{backup_file}", 2) if options[:gzip]
  end

  private

  def prevent_broken_backup
    Signal.trap('SIGINT') do
      FileUtils.rm backup_file
      exit 1
    end
  end

  def run_command(command, statuscode = 1)
    puts "Running '#{command}'"
    yield if block_given?

    _stdout_str, stderr_str, status = Open3.capture3(command)
    report_error(command, stderr_str, statuscode) unless status.exitstatus.zero?
  end

  def report_error(command, err, statuscode)
    warn "There was a problem running '#{command}'"
    warn err
    exit statuscode
  end

  def prevent_overwrite
    return unless File.exist? backup_file

    if options[:force]
      warn "Overwriting #{backup_file}"
    else
      warn "error: #{backup_file} already exists, use --force to overwrite"
      exit 1
    end
  end
end
