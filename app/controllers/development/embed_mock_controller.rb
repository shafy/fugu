# frozen_string_literal: true

module Development
  class EmbedMockController < ApplicationController
    before_action :authenticate_user!

    def index
      @project = Project.where(user: current_user).first
    end
  end
end
