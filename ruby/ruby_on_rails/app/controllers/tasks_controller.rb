class TasksController < ApplicationController
  before_action :set_task, only: %i[complete destroy]

  def index
    render json: { tasks: Task.all }, status: :ok
  end

  def create
    task = current_user.tasks.new(task_params)

    if task.save
      render json: { task: task }, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    render status: :ok
  end

  def complete
    @task.update(completed: true)
    render json: { task: @task }, status: :ok
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title)
  end
end
