require "rack/test"

ENV["RAILS_ENV"] ||= "test"

require_relative "../config/application"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
