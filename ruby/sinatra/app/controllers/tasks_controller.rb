class TasksController < ApplicationController
  def index
    response.status = 200
    current_user.tasks.to_json
  end

  def create
    task = current_user.tasks.new(task_params)

    if task.save
      response.status = 201
      task.to_json
    else
      response.status = 422
      { errors: task.errors.full_messages }.to_json
    end
  end

  def destroy
    task = set_task

    if task
      task.destroy
      response.status = 200
    else
      response.status = 422
      { errors: ["Task must exist"] }.to_json
    end
  end

  def complete
    task = set_task

    if task
      task.update(completed: true)
      response.status = 200
      task.to_json
    else
      response.status = 422
      { errors: ["Task must exist"] }.to_json
    end
  end

  private

  def set_task
    current_user.tasks.find(params[:id])
  end

  def task_params
    params[:task]&.slice(:title) || {}
  end
end
