class TasksController < ApplicationController
  before_action :set_task, only: %i[complete destroy]

  def index
    render json: current_user.tasks, status: :ok
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      render json: @task, status: :created
    else
      render json: { errors: task_errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.present?
      @task.destroy
      render status: :ok
    else
      render json: { errors: { task: "Task must exist" } }, status: :not_found
    end
  end

  def complete
    if @task.present?
      @task.update(completed: true)
      render json: @task, status: :ok
    else
      render json: { errors: { task: "Task must exist" } }, status: :not_found
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
    params.require(:task).permit(:title)
  end
end
