class TasksController < ApplicationController
  before_action :auth
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = @current_user.tasks
  end

  def show
  end

  def new
    @task = Task.new(user: @current_user)
  end

  def edit
  end

  def create
    @task = @current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "Task was successfully destroyed."
  end

  private
    def set_task
      @task = @current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:user_id, :source_page_id, :target_parent_page_id)
    end
end
