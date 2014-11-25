# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rubocop/rake_task'

TheShelf::Application.load_tasks
RuboCop::RakeTask.new
Rake::Task[:default].prerequisites.clear

task :check_all_the_things do
  Rake::Task["rubocop"].invoke
  Rake::Task["spec"].invoke
  Rake::Task["cucumber"].invoke
end

task default: :check_all_the_things
