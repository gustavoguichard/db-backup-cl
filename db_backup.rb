#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path 'lib')

require 'backup_manager'
require 'backup_config'

backup_config = BackupConfig.new

BackupManager.new(backup_config.options) do |backup_manager|
  backup_manager.backup!
  backup_manager.gzip!
end
