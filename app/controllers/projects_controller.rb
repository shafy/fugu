# frozen_string_literal: true

class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def show
    @events = Event
              .where(
                project_id: params[:id],
                name: params[:event].tr!('_', ' ').titleize,
                staging: params[:staging] == 'true'
              )
              .group("date_trunc('day', created_at)::date").count.sort.to_h

    @event_names = Event.order(name: :asc).distinct.pluck(:name)
  end

  def create
    project = Project.create!(name: params[:name])
    ApiKey.create!(project: project)
  end
end
