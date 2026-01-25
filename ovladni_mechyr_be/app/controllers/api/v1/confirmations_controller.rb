# frozen_string_literal: true

module Api
  module V1
    class ConfirmationsController < ApplicationController
      skip_before_action :authenticate_devise_api_token!, only: %i[create resend_confirmation]
      def create
        @user = User.confirm_by_token(params[:confirmation_token])
        if @user.errors.blank?
          head :no_content
        else
          respond_with_error(@user.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def resend_confirmation
        user = User.find_by(email: confirmation_params[:email])
        if user && !user.confirmed?
          user.resend_confirmation_instructions
          head :no_content
        else
          respond_with_error(I18n.t('errors.messages.already_confirmed'), :unprocessable_entity)
        end
      end

      private

      def confirm_by_token
        params.fetch(:user, {}).permit(:confirmation_token)
      end

      def confirmation_params
        params.fetch(:user, {}).permit(:email)
      end
    end
  end
end
