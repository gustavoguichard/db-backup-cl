#!/usr/bin/env ruby
# frozen_string_literal: true

require './backup_manager.rb'
require './backup_config.rb'

backup_config = BackupConfig.new

BackupManager.new(backup_config.options) do |backup_manager|
  backup_manager.backup!
  backup_manager.gzip!
end
