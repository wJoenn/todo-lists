require "kemal"
require "../config/config"

Kemal.config.host_binding = "::1"
add_context_storage_type(Task)

def authenticate_user!(env : HTTP::Server::Context) : User | Nil
  jwt = env.request.headers["AUTHORIZATION"]?
  return unless jwt

  User.by_jwt(jwt)
end

before_all do |env|
  env.response.content_type = "application/json"
end

get "/current_user" do |env|
  user = authenticate_user!(env)

  halt env, status_code: 401 if user.nil?

  env.response.status_code = 200
  user.to_json
end

get "/tasks" do |env|
  user = authenticate_user!(env)

  halt env, status_code: 401 if user.nil?

  Task.all.to_json
end

post "/tasks" do |env|
  user = authenticate_user!(env)

  halt env, status_code: 401 if user.nil?

  task_params = env.params.json["task"].as Hash
  title = task_params["title"]?.try &.as_s?
  task = Task.new({title: title})

  if task.save
    env.response.status_code = 201
    task.to_json
  else
    env.response.status_code = 422
    {errors: task.errors.full_messages}.to_json
  end
end

before_all "/tasks/:id" do |env|
  if env.params.url["id"]?
    id = env.params.url["id"]
    task = Task.find(id)

    if task.nil?
      halt env, status_code: 422, response: ({errors: ["Task must exist"]}.to_json)
    end

    env.set "task", task
  end
end

delete "/tasks/:id" do |env|
  user = authenticate_user!(env)

  halt env, status_code: 401 if user.nil?

  task = env.get("task").as Task
  task.destroy

  env.response.status_code = 200
end

patch "/tasks/:id/complete" do |env|
  user = authenticate_user!(env)

  halt env, status_code: 401 if user.nil?

  task = env.get("task").as Task
  task.update(completed: true)

  env.response.status_code = 200
  task.to_json
end

post "/users" do |env|
  user_params = env.params.json["user"].as Hash
  email = user_params["email"]?.try &.as_s?
  password = user_params["password"]?.try &.as_s?
  password_confirmation = user_params["password_confirmation"]?.try &.as_s?

  user = User.new({:email => email})
  user.password = password
  user.password_confirmation = password_confirmation

  if user.save
    env.response.status_code = 201
    env.response.headers["Authorization"] = user.jwt
    user.to_json
  else
    env.response.status_code = 422
    {errors: user.errors.full_messages}.to_json
  end
end

post "/users/sign_in" do |env|
  user_params = env.params.json["user"].as Hash
  email = user_params["email"]?.try &.as_s?
  password = user_params["password"]?.try &.as_s?

  user = User.where({:email => email}).limit(1).first

  if user.present? && password.present? && user.as(User).authenticate(password.to_s)
    env.response.status_code = 200
    env.response.headers["Authorization"] = user.as(User).jwt
    user.to_json
  else
    env.response.status_code = 401
    {errors: ["Invalid Email or Password"]}.to_json
  end
end

delete "/users/sign_out" do |env|
  user = authenticate_user!(env)

  halt env, status_code: 401 if user.nil?

  user.edit_jti
  user.save

  env.response.status_code = 200
end

Kemal.run
