# frozen_string_literal: true

module Api
  module V1
    class LogoutsController < Devise::Api::TokensController
      def create
        revoke
      end
    end
  end
end
