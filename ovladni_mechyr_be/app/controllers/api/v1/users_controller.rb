# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_devise_api_token!, only: %i[find_by_token]

      def index
        return if authorize_action(roles: %i[admin])

        @pagy, @users = pagy(UsersQuery.call(User.includes(:roles), params).result.distinct, items: params[:items_per_page], page: page_param)
        @pagination = pagy_metadata(@pagy)
      end

      def show
        @current_user = current_devise_api_user
        return user if user == current_devise_api_user
        return user if current_user_is_admin?
        return user if current_user_is_doctor? && (user.patient.doctor == current_devise_api_user.doctor)
        return user if current_user_is_patient? && user.doctor.present?

        render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found
      end

      def update
        set_attribute_id
        return render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found unless authorize_user

        if user.update(user_update_params)
          render :create, status: :ok
        else
          respond_with_error(command.errors[:user].first, :unprocessable_entity)
        end
      end

      def find_by_token
        user = user_by_token

        return unless user.nil?

        render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found
      end

      def forms
        patient = Patient.find_by(user_id: params[:id])
        return render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found if patient.nil?

        @oab_forms = patient.oab_forms if patient.oab_forms.present?
        @ipss_forms = patient.ipss_forms if patient.ipss_forms.present?
        @iciq_forms = patient.iciq_forms if patient.iciq_forms.present?
        @anamnestic_forms = patient.anamnestic_forms if patient.anamnestic_forms.present?
      end

      def diaries
        patient = Patient.find_by(user_id: params[:id])
        return render json: { error: I18n.t('errors.messages.not_found') }.to_json, status: :not_found if patient.nil?

        @voiding_diaries = patient.voiding_diaries.order!(diary_start_date: :desc)
      end

      def destroy
        return if authorize_action(roles: %i[admin])

        if user.destroy!
          head :no_content
        else
          respond_with_error(company.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      private

      def authorize_user
        current_user_is_admin? || user == current_devise_api_user
      end

      def set_attribute_id
        if params[:user][:doctor_attributes].present?
          params[:user][:doctor_attributes][:id] = user.doctor.id
        elsif params[:user][:patient_attributes].present?
          params[:user][:patient_attributes][:id] = user.patient.id
        end
      end

      def user_by_token
        @user_by_token ||= User.find_by_invitation_token(params[:invitation_token], true)
      end

      def user
        @user ||= User.find(params[:id])
      end

      def user_update_params
        allowed_params = [:email, :password, :password_confirmation,
                          { patient_attributes: %i[id gender other_gender full_name assigned_doctor_id next_appointment],
                            doctor_attributes: %i[id full_name workplace working_hours contact_email contact_phone web
                                                  city postal_code street_and_number full_capacity latitude longitude] }]
        allowed_params += %i[password password_confirmation] if current_devise_api_user == user

        params.fetch(:user, {}).permit(allowed_params)
      end
    end
  end
end
