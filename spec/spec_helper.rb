# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'

if ENV['COVERAGE']
  require 'coveralls'
  require 'simplecov'
  Coveralls.wear!('rails') do
    add_filter 'bundle'
  end
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start('rails') do
    add_filter 'bundle'
  end
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/its'
require 'email_spec'
require 'database_cleaner'
require 'xmpp4r'
require 'xmpp4r/muc'
require 'mongoid-rspec'
require 'fabrication'
require 'errbit_plugin/mock_issue_tracker'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include Mongoid::Matchers, :type => :model
  config.alias_example_to :fit, :focused => true

  config.before(:each) do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner.clean
  end

  config.include Haml, type: :helper
  config.include Haml::Helpers, type: :helper
  config.before(:each, type: :helper) do |_|
    init_haml_helpers
  end

  config.infer_spec_type_from_file_location!
end

OmniAuth.config.test_mode = true
