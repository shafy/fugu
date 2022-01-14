# frozen_string_literal: true

class FunnelsController < ApplicationController
  include ApiKeyable
  include Dateable
  include EventNameable

  before_action :set_project, only: %i[show index new create]
  before_action :authorize_project_user, only: %i[index new]
  before_action :show_test_alert, only: %i[show]
  before_action :show_not_active_flash, only: %i[index]
  before_action :set_api_key, only: %i[show new create]
  before_action :set_dates, only: %i[show]
  before_action :set_event_names, only: %i[new]

  after_action :track_event, only: %i[index]

  def index
    return render layout: "data_view" unless @funnels&.first

    #redirect_to project_event_path(@project.name, @event_names&.first&.parameterize)
  end
  
  def show
  end

  def new
    @funnel = Funnel.new
    5.times { @funnel.funnel_steps.build }
  end

  def create
    @funnel = Funnel.new(funnel_params.merge(api_key: @api_key))
    if @funnel.save
      redirect_to project_funnel_path(@project.name, @funnel)
    else
      flash[:error] = "We couldn't create your funnel: #{@funnel.errors.full_messages.first}"
      redirect_to new_project_funnel_path(@project.name), status: :unprocessable_entity
    end
  end

  private

  def funnel_params
    params.require(:funnel).permit(:name, funnel_steps_attributes: %w[event_name])
  end

  def track_event
    FuguService.track("Viewed Funnels")
  end
end
