# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def set_project
    @project = Project.find_by(name: project_name_from_param)
  end

  def authorize_project_user
    return redirect_to projects_path unless current_user

    return redirect_to projects_path unless @project

    return redirect_to projects_path unless current_user == @project.user
  end

  def project_name_from_param
    params[:project_slug].tr('-', ' ').titleize
  end
end
