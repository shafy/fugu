# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include InactiveAlertable

  private

  def show_test_alert
    return unless params[:test] == "true"

    flash.now[:info] =
      "Heads up: You are currently viewing test events. Test events are deleted after 14 days."
  end

  def set_project
    user = User.find_by(hash_id: params[:user_id])
    @project = Project.find_by(name: params[:project_slug]&.downcase, user: user)
  end

  def authorize_project_user
    return redirect_to user_projects_path(params[:user_id]) unless @project

    # don't show test data in public projects
    if !current_user && @project.public && params[:test] == "true"
      return redirect_to user_projects_path(params[:user_id])
    end

    # don't authorize is project is public
    return if @project.public

    return redirect_to user_projects_path(params[:user_id]) unless current_user == @project.user
  end
end
