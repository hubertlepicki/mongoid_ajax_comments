# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :selenium
Capybara.default_selector = :css

# Load support files
require "#{File.dirname(__FILE__)}/support/clean_case.rb"
require "#{File.dirname(__FILE__)}/support/integration_case.rb"
