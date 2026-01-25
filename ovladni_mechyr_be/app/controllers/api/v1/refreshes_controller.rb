# frozen_string_literal: true

module Api
  module V1
    class RefreshesController < Devise::Api::TokensController
      # rubocop:disable Metrics/AbcSize
      def create
        unless Devise.api.config.refresh_token.enabled
          error_response = Devise::Api::Responses::ErrorResponse.new(request,
                                                                     resource_class:,
                                                                     error: :refresh_token_disabled)

          return render json: error_response.body, status: error_response.status
        end

        if current_devise_api_refresh_token.blank?
          error_response = Devise::Api::Responses::ErrorResponse.new(request, error: :invalid_token,
                                                                              resource_class:)

          return render json: error_response.body, status: error_response.status
        end

        if current_devise_api_refresh_token.revoked?
          error_response = Devise::Api::Responses::ErrorResponse.new(request, error: :revoked_token,
                                                                              resource_class:)

          return render json: error_response.body, status: error_response.status
        end

        Devise.api.config.before_refresh.call(current_devise_api_refresh_token, request)

        @service = Devise::Api::TokensService::Refresh.new(devise_api_token: current_devise_api_refresh_token).call

        if @service.success?
          token_response = Devise::Api::Responses::TokenResponse.new(request, token: @service.success,
                                                                              action: __method__)

          Devise.api.config.after_successful_refresh.call(@service.success.resource_owner, @service.success, request)
          call_devise_trackable!(@service.success.resource_owner)

          return render :create, status: token_response.status
        end

        error_response = Devise::Api::Responses::ErrorResponse.new(request,
                                                                   resource_class:,
                                                                   **@service.failure)
        render json: error_response.body, status: error_response.status
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
