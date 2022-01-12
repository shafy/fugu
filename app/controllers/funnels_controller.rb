# frozen_string_literal: true

class FunnelsController < ApplicationController
  before_action :set_project, only: %i[index new]
  before_action :authorize_project_user, only: %i[index new]
  before_action :show_test_alert, only: %i[index]
  before_action :show_not_active_flash, only: %i[index]

  include ApiKeyable
  include Dateable

  after_action :track_event, only: %i[index]

  def index
    return render layout: "data_view" unless @funnels&.first

    #redirect_to project_event_path(@project.name, @event_names&.first&.parameterize)
  end
  
  def show
  end

  def new
    #@funnel = Funnel.new
    #2.times { @funnel.funnel_steps.build }
    render layout: "data_view"
  end

  def create
  end

  private

  def track_event
    FuguService.track("Viewed Funnels")
  end
end
