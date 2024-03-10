require "sinatra"
require_relative "config/application"

helpers do
  def env
    request.params.merge!(params)
    OpenStruct.new({ request:, response: }.merge(request.env))
  end
end

get("/tasks") { TasksController.authenticate(env)&.index }
post("/tasks") { TasksController.authenticate(env)&.create }
delete("/tasks/:id") { TasksController.authenticate(env)&.destroy }
patch("/tasks/:id/complete") { TasksController.authenticate(env)&.complete }

get("/current_user") { Users::RegistrationsController.authenticate(env)&.show }
post("/users") { Users::RegistrationsController.new(env).create }
post("/users/sign_in") { Users::SessionsController.new(env).create }
delete("/users/sign_out") { Users::SessionsController.authenticate(env)&.destroy }

set :port, 3000
