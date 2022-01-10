# frozen_string_literal: true

class ProjectsController < ApplicationController
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
      redirect_to project_events_path(@project.name)
    else
      flash.now[:error] = "We couldn't create your project: #{@project.errors.full_messages.first}"
      render new_project_path, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find_by(name: params[:slug]&.downcase, user: current_user)
    if @project.destroy
      flash[:notice] = "Your project was successfully deleted"
      redirect_to projects_path
    else
      flash[:error] = "We couldn't delete the project: #{@project.errors.full_messages.first}"
      redirect_to project_events_path(@project.name)
    end
  end

  def settings; end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
