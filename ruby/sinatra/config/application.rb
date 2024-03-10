ENV["RAILS_ENV"] ||= "development"

require "bundler"
Bundler.require(:default, ENV["RAILS_ENV"].to_sym)

unless ENV["RAILS_ENV"] == "production"
  Dotenv.load
end

Dir["#{__dir__}/initializers/*.rb"].each { |file| require file }
Dir["#{__dir__}/../app/**/*.rb"].each { |file| require file }
