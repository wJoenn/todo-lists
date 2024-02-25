require "sinatra"
require_relative "config/application"

get "/tasks" do
  status 200
  Task.all.to_json
end

post "/tasks" do
  body = JSON.parse(request.body.read).deep_transform_keys(&:to_sym)
  task_params = body[:task].slice(:title)
  task = Task.new(task_params)

  if task.save
    status 200
    task.to_json
  else
    status 404
    { errors: task.errors.full_messages }.to_json
  end
end

delete "/tasks/:id" do
  task = Task.find(params["id"])
  task.destroy
  status 200
end

patch "/tasks/:id/complete" do
  task = Task.find(params["id"])
  task.update(completed: true)
  status 200
end
