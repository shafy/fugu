# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show]
  before_action :authorize_project_user, only: %i[show]

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

    start_date = Event.where(name: @selected_event, api_key: api_key).minimum("created_at")
    end_date = Event.where(name: @selected_event, api_key: api_key).maximum("created_at")

    @properties = Event.distinct_properties(@selected_event, api_key.id)
    @property_values = Event.distinct_property_values(@selected_event, api_key.id, "color")

    events_array = Event.with_aggregation(
      @selected_event,
      api_key.id,
      aggregation,
      "color",
      @property_values.join(","),
      start_date,
      end_date
    )

    @dates = events_array.uniq { |e| e["date"]}.map { |d| d["date"] }
    @events = events_array.group_by { |e| e["property_value"] }.each_value { |v| v.map! { |vv| vv["count"]} }
    
    puts @dates
    puts @events
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(name: project_params[:name], user: current_user)
    if @project.save
      @project.create_api_keys
      redirect_to project_path(@project.name)
    else
      flash[:error] = "We couldn't create your project: #{@project.errors.full_messages.first}"
      render new_project_path, status: :unprocessable_entity
    end
  end

  private

  def aggregation
    Event.aggregations.key?(params[:agg]) ? Event.aggregations[params[:agg]] : 'day'
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.find_by(name: params[:slug].downcase)
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
end
