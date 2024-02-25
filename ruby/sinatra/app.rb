require "sinatra"
require_relative "config/application"

get "/tasks" do
  status 200
  Task.all.to_json
end
