# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rubocop/rake_task'

TheShelf::Application.load_tasks
RuboCop::RakeTask.new
Rake::Task[:default].prerequisites.clear

if defined? RSpec
  task(:spec).clear
  desc "Run all specs/features in spec directory"
  RSpec::Core::RakeTask.new(:spec => 'db:test:prepare') do |t|
    t.pattern = './spec/**/*{_spec.rb,.feature}'
  end
end

task :check_all_the_things do
  Rake::Task["rubocop"].invoke
  Rake::Task["spec"].invoke
end

task default: :check_all_the_things
