# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordsController < ApplicationController
        include ActionController::RequestForgeryProtection
        skip_before_action :authenticate_devise_api_token!
        protect_from_forgery

        def forgot
          return respond_with_error(I18n.t('password_reset.email_not_present')) if email_params[:email].blank?

          if user.present?
            @token = user.send_reset_password_instructions
          else
            respond_with_error(I18n.t('password_reset.email_not_found'))
          end
        end

        def reset
          return respond_with_error(I18n.t('password_reset.token_not_present'), :unprocessable_entity) if reset_params[:token].blank?

          user = User.with_reset_password_token(reset_params[:token].to_s)
          if user.present? && user.reset_password_period_valid?
            if user.reset_password(reset_params[:password], reset_params[:password_confirmation])
              render json: { status: 'ok' }, status: :ok
            else
              respond_with_error(user.errors.full_messages, :unprocessable_entity)
            end
          else
            respond_with_error(I18n.t('password_reset.link_not_valid'))
          end
        end

        private

        def user
          @user ||= User.find_by(email: email_params[:email])
        end

        def email_params
          params.require(:user).permit(:email)
        end

        def reset_params
          params.require(:user).permit(:token, :password, :password_confirmation)
        end
      end
    end
  end
end
