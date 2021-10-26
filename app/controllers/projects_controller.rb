# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show settings destroy]
  before_action :authorize_project_user, only: %i[show]
  before_action :set_api_key, only: %i[show]
  before_action :set_event_names, only: %i[show]
  before_action :set_selected_event, only: %i[show]
  before_action :set_dates, only: %i[show]
  before_action :set_property, only: %i[show]
  before_action :set_properties, only: %i[show]
  before_action :set_property_values, only: %i[show]
  before_action :set_aggregation, only: %i[show]
  before_action :show_test_alert, only: %i[show]
  before_action :show_not_active_flash, only: %i[index show new settings]

  def index
    @projects = Project.where(user: current_user)
  end

  def show
    # TODO
    # redirect_to dashboard unless project
    return unless @selected_event

    events_array = Event.with_aggregation(
      event_name: @selected_event,
      api_key_id: @api_key.id,
      agg: @aggregation,
      prop_name: @property,
      prop_values: @property_values,
      start_date: @start_date,
      end_date: @end_date
    )

    @dates = events_array.uniq { |e| e["date"]}.map { |d| d["date"] }
    @events = Event.format_for_chart(events_array)
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

  def destroy
    if @project.destroy
      flash[:notice] = "Your project was successfully deleted"
      redirect_to projects_path
    else
      flash[:error] = "We couldn't delete the project: #{@project.errors.full_messages.first}"
      redirect_to project_path(@project.name)
    end
  end

  def settings
  end

  private

  def show_test_alert
    return unless params[:test] == "true"

    flash.now[:info] = "Heads up: You are currently viewing test data. Test data is deleted after 14 days."
  end

  def set_api_key
    @api_key = params[:test] == "true" ? @project.api_key_test : @project.api_key_live
  end

  def set_event_names
    @event_names = Event.where(api_key: @api_key).order(name: :asc).distinct.pluck(:name)
  end

  def set_dates
    @start_date = Event.where(name: @selected_event, api_key: @api_key).minimum("created_at")
    @end_date = Event.where(name: @selected_event, api_key: @api_key).maximum("created_at")
  end

  def set_properties
    @properties = Event.distinct_properties(@selected_event, @api_key.id)
  end

  def set_aggregation
    a = Event.aggregations.key?(params[:agg]) ? Event.aggregations[params[:agg]] : "day"
    @aggregation = CGI.escapeHTML(a)
  end

  def set_property
    return if !params.key?("prop") || params[:prop] == "All"

    @property = CGI.escapeHTML(params[:prop])
  end

  def set_property_values
    return if @property.blank? || @property.casecmp?("all")

    @property_values = Event.distinct_property_values(@selected_event, @api_key.id, @property)
    @property_values.map! { |p| p.gsub(",", "\\,")}
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def set_project
    @project = Project.find_by(name: params[:slug].downcase, user: current_user)
  end

  def authorize_project_user
    return redirect_to projects_path unless current_user

    return redirect_to projects_path unless @project

    return redirect_to projects_path unless current_user == @project.user
  end

  def set_selected_event
    ev = if params[:event]
           e = params[:event].tr('-', ' ').titleize
           Event.exists?(name: e, api_key: @api_key) ? e : @event_names.first
         else
           @event_names.first
         end
    @selected_event = CGI.escapeHTML(ev) if ev
  end
end
