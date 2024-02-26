require "sinatra"
require_relative "config/application"

post "*" do
  @parsed_params = params["params"]
  @parsed_params ||= JSON.parse(request.body.read)
  @parsed_params.deep_transform_keys!(&:to_sym)
  pass
end

get "/tasks" do
  status 200
  Task.all.to_json
end

post "/tasks" do
  task_params = @parsed_params[:task].slice(:title)
  task = Task.new(task_params)

  if task.save
    status 202
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
  task.to_json
end
