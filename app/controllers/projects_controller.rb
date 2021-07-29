# frozen_string_literal: true

class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def show
    project = Project.find_by!(name: parse_project_name(params[:project_slug]))
    api_key = if params[:test] == 'true'
                project.api_key_test
              else
                project.api_key_live
              end
    @events = Event
              .where(
                api_key: api_key,
                name: params[:event].tr('-', ' ').titleize
              )
              .group("date_trunc('day', created_at)::date").count.sort.to_h

    @event_names = Event.order(name: :asc).distinct.pluck(:name)
  end

  def create
    Project.create!(name: params[:name])
  end

  private

  def parse_project_name(project_name)
    project_name.tr('-', ' ').titleize
  end
end
