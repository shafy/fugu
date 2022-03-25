# frozen_string_literal: true

module ApplicationHelper
  def evergreen_params
    # params that we often pass along
    { test: params[:test], embed: params[:embed] }
  end
end
