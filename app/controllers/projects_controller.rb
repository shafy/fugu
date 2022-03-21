# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_project, only: %i[settings]
  before_action :show_not_active_flash, only: %i[settings]

  def index
    @projects = Project.where(user: current_user)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(name: project_params[:name], user: current_user)
    if @project.save
      @project.create_api_keys
      redirect_to user_project_events_path(current_user.hash_id, @project.name)
    else
      flash.now[:error] = "We couldn't create your project: #{@project.errors.full_messages.first}"
      render "projects/new", status: :unprocessable_entity
    end
  end

  def edit
    user = User.find_by(hash_id: params[:user_id])
    @project = Project.find_by(name: params[:slug]&.downcase, user: user)
  end

  def update
    @project = Project.find(project_params[:project_id])

    if @project.update(name: project_params[:name], public: project_params[:public])
      redirect_to user_project_settings_path(current_user.hash_id, @project.name.downcase)
    else
      flash.now[:error] = "We couldn't update your project: #{@project.errors.full_messages.first}"
      render "projects/edit", status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find_by(name: params[:slug]&.downcase, user: current_user)
    if @project.destroy
      flash[:notice] = "Your project was successfully deleted"
      redirect_to user_projects_path(current_user)
    else
      flash[:error] = "We couldn't delete the project: #{@project.errors.full_messages.first}"
      redirect_to user_project_events_path(current_user.hash_id, @project.name)
    end
  end

  def settings; end

  private

  def project_params
    params.require(:project).permit(:project_id, :user_id, :name, :public)
  end
end
