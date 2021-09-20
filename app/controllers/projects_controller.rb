# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show]
  before_action :authorize_project_user, only: %i[show]

  AGG_HASH = {
    'd' => 'day',
    'w' => 'week',
    'm' => 'month',
    'y' => 'year'
  }.freeze

  def index
    @projects = Project.where(user: current_user)
  end

  def show
    # TODO
    # redirect_to user_dashbaord unless project

    api_key = if params[:test] == 'true'
                @project.api_key_test
              else
                @project.api_key_live
              end

    @event_names = Event.where(api_key: api_key).order(name: :asc).distinct.pluck(:name)
    set_selected_event

    @events = unless @event_names.empty?
                Event
                  .where(
                    api_key: api_key,
                    name: @selected_event
                  )
                  .group("date_trunc('#{aggregation}', created_at)::date").count.sort.to_h
              end
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(name: project_params[:name], user: current_user)
    if @project.save
      redirect_to project_path(@project.name.parameterize)
    else
      flash[:error] = "We couldn't create your project: #{@project.errors.full_messages.first}"
      render new_project_path, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find_by(name: params[:project_slug].downcase)
  end

  def authorize_project_user
    return redirect_to projects_path unless current_user

    return redirect_to projects_path unless @project

    return redirect_to projects_path unless current_user == @project.user
  end

  def set_selected_event
    @selected_event = if params[:event]
                        params[:event].tr('-', ' ').titleize
                      else
                        @event_names.first
                      end
  end

  def aggregation
    AGG_HASH.key?(params[:agg]) ? AGG_HASH[params[:agg]] : 'day'
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
