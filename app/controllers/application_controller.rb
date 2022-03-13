# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include InactiveAlertable

  private

  def show_test_alert
    return unless params[:test] == "true"

    flash.now[:info] =
      "Heads up: You are currently viewing test events. Test events are deleted after 14 days."
  end

  def set_project
    @project = Project.find_by(name: params[:project_slug]&.downcase, user: current_user)
  end

  def authorize_project_user
    return redirect_to projects_path unless current_user

    return redirect_to projects_path unless @project

    return redirect_to projects_path unless current_user == @project.user
  end
end
