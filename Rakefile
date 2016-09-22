require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => [:spec]

desc 'Run the specs.'
RSpec::Core::RakeTask.new do |task|
  task.pattern = 'test/*_test.rb'
  task.verbose = false
end

