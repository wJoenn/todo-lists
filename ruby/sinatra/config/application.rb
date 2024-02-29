ENV["RAILS_ENV"] ||= "development"

require "bundler"
Bundler.require(:default, ENV["RAILS_ENV"].to_sym)

require_relative "environments/#{ENV["RAILS_ENV"]}"
Dir["#{__dir__}/initializers/*.rb"].each { |file| require file }
Dir["#{__dir__}/../app/**/*.rb"].each { |file| require file }

set :port, 3000
