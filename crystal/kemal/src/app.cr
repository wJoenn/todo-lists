require "../config/config"

before_all do |env|
  env.response.content_type = "application/json"
end

get "/current_user" { |env| Users::RegistrationsController.authenticate?(env).try &.show }
get "/tasks" { |env| TasksController.authenticate?(env).try &.index }
post "/tasks" { |env| TasksController.authenticate?(env).try &.create }
delete "/tasks/:id" { |env| TasksController.authenticate?(env).try &.destroy }
patch "/tasks/:id/complete" { |env| TasksController.authenticate?(env).try &.complete }
post "/users" { |env| Users::RegistrationsController.new(env).create }
post "/users/sign_in" { |env| Users::SessionsController.new(env).create }
delete "/users/sign_out" { |env| Users::SessionsController.authenticate?(env).try &.destroy }

Kemal.config.host_binding = "::1"
Kemal.run
