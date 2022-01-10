# frozen_string_literal: true

class FunnelsController < ApplicationController
  before_action :set_project, only: %i[index]
  before_action :authorize_project_user, only: %i[index]
  before_action :show_test_alert, only: %i[index]
  before_action :show_not_active_flash, only: %i[index]

  include ApiKeyable
  include Dateable

  after_action :track_event, only: %i[index]

  def index
  end

  private

  def track_event
    FuguService.track("Viewed Funnels")
  end
end
