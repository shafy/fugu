# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :redirect_subdomain

  def redirect_subdomain
    redirect_to "https://fugu.lol#{request.fullpath}", status: :moved_permanently if
      request.host == 'www.fugu.lol'
  end
end
