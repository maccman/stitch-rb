require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test_helper.rb', 'test/test_*.rb']
  t.libs << "."
end

task :default => :test