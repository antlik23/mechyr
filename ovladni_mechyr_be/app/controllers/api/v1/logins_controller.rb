# frozen_string_literal: true

module Api
  module V1
    class LoginsController < Devise::Api::TokensController
      def create
        command = Logins::Create.call(sign_in_params, request)
        if command.success?
          @token = command.result
        else
          respond_with_error(command.errors[:login].first, :unauthorized)
        end
      end
    end
  end
end
