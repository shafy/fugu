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

    @events = ActiveRecord::Base.connection.execute(
      event_sql_query(@selected_event, api_key.id, aggregation)
    ).to_a
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
    AGG_HASH.key?(params[:agg]) ? AGG_HASH[params[:agg]] : 'day'
  end

  # rubocop:disable Metrics/MethodLength
  def event_sql_query(event_name, api_key_id, aggregation)
    %(
      WITH range_values AS (
        SELECT date_trunc('#{aggregation}', min(created_at)) as minval,
               date_trunc('#{aggregation}', max(created_at)) as maxval
        FROM events
        WHERE name='#{event_name}' AND api_key_id='#{api_key_id}'),

      week_range AS (
        SELECT generate_series(minval, maxval, '1 #{aggregation}'::interval) as date
        FROM range_values
      ),

      weekly_counts AS (
        SELECT date_trunc('#{aggregation}', created_at) as date,
               count(*) as count
        FROM events
        WHERE name='#{event_name}' AND api_key_id='#{api_key_id}'
        GROUP BY 1
      )

      SELECT week_range.date::date,
        CASE WHEN weekly_counts.count is NULL THEN 0 ELSE weekly_counts.count END AS count
      FROM week_range
      LEFT OUTER JOIN weekly_counts on week_range.date = weekly_counts.date;
    )
  end
  # rubocop:enable Metrics/MethodLength

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
