# frozen_string_literal: true

module Logins
  class Create < ::Devise::Api::TokensController
    prepend SimpleCommand

    attr_reader :params, :request, :resource_class

    def initialize(params, request)
      super()
      @params = params
      @request = request
      @resource_class = User
    end

    def call
      before_sign_in
      return error_message unless sign_in.success?

      after_sign_in
      @token
    end

    private

    def before_sign_in
      Devise.api.config.before_sign_in.call(params, request, resource_class)
    end

    def after_sign_in
      @token = sign_in.success
      call_devise_trackable!(@token.resource_owner)
      Devise::Api::Responses::TokenResponse.new(request, token: sign_in.success, action: :create)
      Devise.api.config.after_successful_sign_in.call(@token.resource_owner, @token, request)
    end

    def sign_in
      @sign_in ||= Devise::Api::ResourceOwnerService::SignIn.new(params:, resource_class:).call
    end

    def error_message
      errors.add(:login, Devise::Api::Responses::ErrorResponse.new(request, resource_class:, **sign_in.failure).body[:error_description].first)
      false
    end
  end
end
