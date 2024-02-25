require "sinatra"

set :port, 3000

get "/tasks" do
  status 200
  [{ id: 1, title: "My task", completed: false }].to_json
end
