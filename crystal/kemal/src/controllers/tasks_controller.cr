class TasksController < ApplicationController
  def index
    response.status_code = 200
    current_user.tasks.to_json
  end

  def create
    task = Task.new(task_params)
    task.user_id = current_user.id

    if task.save
      response.status_code = 201
      return task.to_json
    end

    response.status_code = 422
    {errors: task_errors(task)}.to_json
  end

  def destroy
    task = set_task

    if task
      task.destroy
      return response.status_code = 200
    end

    response.status_code = 404
    {errors: {task: "Task must exist"}}.to_json
  end

  def complete
    task = set_task

    if task
      task.update(completed: true)
      response.status_code = 200
      return task.to_json
    end

    response.status_code = 404
    {errors: {task: "Task must exist"}}.to_json
  end

  private def set_task : Task?
    id = params.url["id"]
    current_user.tasks.find { |user_task| user_task.id == id.to_i }
  end

  private def task_errors(task) : Hash
    errors = task.errors
    errors.messages.map { |attribute, message| [attribute, errors.full_message(attribute, message.first)] }.to_h
  end

  private def task_params : NamedTuple
    task_params = params.json["task"].as Hash

    {title: task_params["title"]?.try &.as_s?}
  end
end
