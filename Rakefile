#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

Bundler::GemHelper.install_tasks

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each {|f| load f }
require 'rspec/core'
require 'rspec/core/rake_task'

desc 'Run all specs in spec directory (excluding plugin specs)'
RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')

task :default => :spec
task 'konacha:serve' => 'app:konacha:serve'
task 'konacha:run' => 'app:konacha:run'
