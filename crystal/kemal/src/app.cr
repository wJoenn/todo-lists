require "kemal"
require "../config/config"

Kemal.config.host_binding = "::1"
add_context_storage_type(Task)

before_all do |env|
  env.response.content_type = "application/json"
end

get "/tasks" do
  Task.all.to_json
end

post "/tasks" do |env|
  task_params = env.params.json["task"].as Hash
  title = task_params["title"].as_s?
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
  task = env.get("task").as Task
  task.destroy

  env.response.status_code = 200
end

patch "/tasks/:id/complete" do |env|
  task = env.get("task").as Task
  task.update(completed: true)

  env.response.status_code = 200
  task.to_json
end

Kemal.run
