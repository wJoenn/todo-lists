require "bundler"
Bundler.require(:default)

ENV["RAILS_ENV"] ||= "development"

Dir["#{__dir__}/initializers/*.rb"].each { |file| require file }
Dir["#{__dir__}/../models/**/*.rb"].each { |file| require file }
Dir["#{__dir__}/../services/**/*.rb"].each { |file| require file }

set :port, 3000
