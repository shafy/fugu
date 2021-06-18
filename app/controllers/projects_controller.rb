# frozen_string_literal: true

class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def show
    @events = Event
              .where(
                project: Project.find_by!(name: parse_project_name(params[:project_slug])),
                name: params[:event].tr('-', ' ').titleize,
                staging: params[:staging] == 'true'
              )
              .group("date_trunc('day', created_at)::date").count.sort.to_h

    @event_names = Event.order(name: :asc).distinct.pluck(:name)
  end

  def create
    project = Project.create!(name: params[:name])
    ApiKey.create!(project: project)
  end

  private

  def parse_project_name(project_name)
    project_name.tr('-', ' ').titleize
  end
end
