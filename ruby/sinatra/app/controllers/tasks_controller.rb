class TasksController < ApplicationController
  def index
    response.status = 200
    current_user.tasks.to_json
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      response.status = 201
      @task.to_json
    else
      response.status = 422
      { errors: task_errors }.to_json
    end
  end

  def destroy
    set_task

    if @task.present?
      @task.destroy
      response.status = 200
    else
      response.status = 404
      { errors: { task: "Task must exist" } }.to_json
    end
  end

  def complete
    set_task

    if @task.present?
      @task.update(completed: true)
      response.status = 200
      @task.to_json
    else
      response.status = 404
      { errors: { task: "Task must exist" } }.to_json
    end
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def task_errors
    @task.errors.map { |error| [error.attribute, error.full_message] }.to_h
  end

  def task_params
    params[:task]&.slice(:title) || {}
  end
end
