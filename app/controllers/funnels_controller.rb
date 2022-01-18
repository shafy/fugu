# frozen_string_literal: true

class FunnelsController < ApplicationController
  include ApiKeyable
  include Dateable
  include EventNameable

  before_action :set_project, only: %i[show index new create]
  before_action :authorize_project_user, only: %i[index new]
  before_action :show_test_alert, only: %i[show index]
  before_action :show_test_funnel_creation_alert, only: %i[new]
  before_action :show_not_active_flash, only: %i[index]
  before_action :set_api_key, only: %i[index show new create]
  before_action :set_dates, only: %i[show]
  before_action :set_event_names, only: %i[new]
  before_action :set_funnel, only: %i[show]
  before_action :set_funnel_names, only: %i[index show]
  before_action :set_funnel_event_names, only: %i[show]
  before_action :build_funnel, only: %i[create]

  after_action :track_event, only: %i[index]

  def index
    return render layout: "data_view" unless @funnel_names&.first

    redirect_to project_funnel_path(@project.name, @funnel_names.first.parameterize)
  end

  def show
    unless @funnel
      return redirect_to project_funnels_path(@project.name, params: { test: params[:test] })
    end

    @funnel_data = @funnel_event_names.map do |e|
      Event.where(name: e, api_key: @api_key, created_at: @start_date..@end_date).count
    end
    render layout: "data_view"
  end

  def new
    @funnel = Funnel.new
    5.times { @funnel.funnel_steps.build }
  end

  def create
    if @funnel.save
      redirect_to project_funnel_path(
        @project.name,
        @funnel.name.parameterize,
        params: { test: params[:test] }
      )
    else
      flash[:error] = "We couldn't create your funnel: #{@funnel.errors.full_messages.first}"
      redirect_to new_project_funnel_path(
        @project.name,
        params: { test: params[:test] }
      ), status: :unprocessable_entity
    end
  end

  private

  def funnel_params
    params.require(:funnel).permit(:name, funnel_steps_attributes: %w[event_name])
  end

  def track_event
    FuguService.track("Viewed Funnels")
  end

  def build_funnel
    @funnel = Funnel.new(funnel_params.merge(api_key: @api_key))
  end

  def set_funnel
    @funnel = Funnel.find_by(name: params[:slug].tr("-", " ").titleize.strip, api_key: @api_key)
  end

  def set_funnel_names
    @funnel_names = Funnel.where(api_key: @api_key).pluck(:name)
  end

  def set_funnel_event_names
    @funnel_event_names = @funnel&.funnel_steps&.pluck(:event_name)
  end

  def show_test_funnel_creation_alert
    return unless params[:test] == "true"

    flash.now[:info] = "You are creating a funnel in test mode. "\
                       "This means that you can only select events tracked in test mode. "\
                       "Unlike test events, test funnels are not deleted after 14 days."
  end
end
