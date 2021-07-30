# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def show
    project = Project.find_by(name: project_name_from_param)

    # TODO
    # redirect_to user_dashbaord unless project

    api_key = if params[:test] == 'true'
                project.api_key_test
              else
                project.api_key_live
              end

    @event_names = Event.where(api_key: api_key).order(name: :asc).distinct.pluck(:name)
    set_selected_event

    @events = unless @event_names.empty?
                Event
                  .where(
                    api_key: api_key,
                    name: @selected_event
                  )
                  .group("date_trunc('day', created_at)::date").count.sort.to_h
              end
  end

  def create
    Project.create!(name: params[:name])
  end

  private

  def project_name_from_param
    params[:project_slug].tr('-', ' ').titleize
  end

  def set_selected_event
    @selected_event = if params[:event]
                        params[:event].tr('-', ' ').titleize
                      else
                        @event_names.first
                      end
  end
end
