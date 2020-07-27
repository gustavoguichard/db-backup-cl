require 'rdoc/task'
require 'rubygems'
require 'rubygems/package_task'
require 'cucumber'
require 'cucumber/rake/task'

RDoc::Task.new do |rdoc|
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rdoc.title = 'db_backup - Backup MySQL Databases'
end

Cucumber::Rake::Task.new(:features) do |t|
  opts = "features --format pretty -x"
  opts += " --tags #{ENV['TAGS']}" if ENV['TAGS']
  t.cucumber_opts = opts
  t.fork = false
end

spec = eval(File.read('db_backup.gemspec'))
Gem::PackageTask.new(spec) do |pkg|
end
