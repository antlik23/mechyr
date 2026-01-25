# frozen_string_literal: true

module Api
  module V1
    class InvitationsController < Devise::InvitationsController
      skip_before_action :authenticate_devise_api_token!, only: :update
      respond_to :json

      def create
        existing_user = User.find_by(email: invite_params[:email])
        return respond_with_error(I18n.t('errors.messages.email_already_exists')) if existing_user.present?

        command = Invitations::Create.call(current_devise_api_user, invite_params)

        if command.success?
          @user = command.result
          render :create, status: :created
        else
          respond_with_error(command.errors[:invitation].first, :unprocessable_entity)
        end
      end

      def resend_invitation
        if user.invitation_accepted_at.nil?
          user.invite!(current_devise_api_user)
          render :create, status: :created
        else
          respond_with_error(I18n.t('errors.messages.invitation_accepted'), :unprocessable_entity)
        end
      end

      def update
        command = Invitations::Accept.call(accept_invitation_params, request)

        if command.success?
          @token = command.result
          render :update, status: :accepted
        else
          respond_with_error(command.errors[:invitation].first, :unprocessable_entity)
        end
      end

      private

      def user
        @user ||= User.find(resend_invitation_params[:id])
      end

      def authenticate_inviter!
        authenticate_devise_api_token!
      end

      def resend_invitation_params
        params.require(:user).permit(:id)
      end

      def invite_params
        permitted_params = params.require(:user).permit(:email)
        permitted_params[:roles] = ['doctor']

        permitted_params
      end

      def accept_invitation_params
        params.require(:user).permit(:password, :password_confirmation, :invitation_token, doctor_attributes: [:full_name])
      end
    end
  end
end
