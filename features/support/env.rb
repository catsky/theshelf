require './features/support/goodreads_helpers'
require './features/support/webmock_helpers'
require 'capybara/session'
require 'cucumber/rails'
require 'pry'
require 'factory_girl'

begin
  FactoryGirl.find_definitions
rescue
end

def default_javascript_driver
  ENV['WEB_TEST_JS_DRIVER'].try(:to_sym) || :webkit
end

Capybara.javascript_driver = default_javascript_driver

Before('@selenium') do
  Capybara.javascript_driver = :selenium
end

After('@selenium') do
  Capybara.javascript_driver = default_javascript_driver
end

Capybara.always_include_port = true
Capybara.default_wait_time = 10

include FactoryGirl::Syntax::Methods

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

WebMock.disable_net_connect!(allow_localhost: true)

World(GoodreadsHelpers, WebmockHelpers)
