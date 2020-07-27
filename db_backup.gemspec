# frozen_string_literal: true

require File.join([File.dirname(__FILE__), 'lib', 'db_backup', 'version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'db_backup'
  s.version = DbBackup::VERSION
  s.author = 'Gustavo Guichard'
  s.email = 'gustavoguichard@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Backup one or more MySQL databases'
  s.files = `git ls-files`.split("\n")
  s.require_paths << 'lib'
  s.extra_rdoc_files = ['README.rdoc']
  s.bindir = 'bin'
  s.executables << 'db_backup'
  s.add_development_dependency('aruba')
  s.add_development_dependency('rake')
  s.add_development_dependency('cucumber')
  s.add_development_dependency('rdoc')
end
