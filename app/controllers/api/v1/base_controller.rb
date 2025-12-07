# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      before_action :doorkeeper_authorize!

      private

      def current_resource_owner
        @current_resource_owner ||= Admin.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
