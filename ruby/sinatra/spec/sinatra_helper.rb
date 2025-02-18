ENV["RAILS_ENV"] ||= "test"

require "spec_helper"
require "simplecov"
SimpleCov.start

Bundler.require(:test)

require_relative "../app"

FactoryBot.find_definitions

def app
  Sinatra::Application
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
