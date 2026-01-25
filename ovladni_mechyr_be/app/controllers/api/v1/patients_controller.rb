# frozen_string_literal: true

module Api
  module V1
    class PatientsController < ApplicationController
      before_action :set_patient, only: %i[approve reject]
      def request_assignment
        return if authorize_action(roles: %i[patient])

        patient = current_devise_api_user.patient
        doctor = Doctor.find_by(user_id: params[:patient][:doctor_id])

        return render json: { error: I18n.t('errors.messages.condition_not_met') }.to_json, status: :forbidden unless patient.can_be_assigned && !doctor.full_capacity

        return render json: { error: I18n.t('errors.messages.must_agree') }.to_json, status: :forbidden if params[:patient][:agreed_to_share_info] == false

        if patient.update(request_assignment_params.merge(approved: false, doctor_id: doctor.id))
          head :no_content

          UserMailer.request_assignment_email(doctor,
                                              patient,
                                              params[:email][:custom_message]).deliver_later
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def approve
        return if authorize_action(roles: %i[doctor])

        if @patient.update(approve_params)
          head :no_content
          UserMailer.approve_email(current_devise_api_user.doctor, @patient).deliver_later
        else
          respond_with_error(@patient.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def reject
        return if authorize_action(roles: %i[doctor admin])

        if @patient.update(reject_params)
          head :no_content
          UserMailer.reject_email(current_devise_api_user.doctor, @patient).deliver_later
        else
          respond_with_error(@patient.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def index
        return if authorize_action(roles: %i[doctor admin])

        if current_user_is_doctor?
          current_doctor = current_devise_api_user.doctor
          @pagy, @patients = pagy(PatientsQuery.call(current_doctor.patients.where(approved: true), params).result, items: params[:items_per_page], page: page_param)
        else
          @pagy, @patients = pagy(PatientsQuery.call(Patient.all, params).result, items: params[:items_per_page], page: page_param)
        end
        @pagination = pagy_metadata(@pagy)
      end

      def list_to_be_approved
        return if authorize_action(roles: %i[doctor admin])

        if current_user_is_doctor?
          current_doctor = current_devise_api_user.doctor
          @pagy, @patients = pagy(PatientsQuery.call(current_doctor.patients.where(approved: false), params).result, items: params[:items_per_page], page: page_param)
        else
          @pagy, @patients = pagy(PatientsQuery.call(Patient.where(approved: false), params).result, items: params[:items_per_page], page: page_param)
        end
        @pagination = pagy_metadata(@pagy)
      end

      private

      def set_patient
        @patient = Patient.find(params[:patient_id])
      end

      def request_assignment_params
        params.fetch(:patient, {}).permit(:agreed_to_share_info)
      end

      def reject_params
        { doctor_id: nil, approved: false, agreed_to_share_info: nil, next_appointment: nil }
      end

      def approve_params
        patient_params = params.fetch(:patient, {})
        next_appointment = patient_params[:next_appointment]
        {
          next_appointment: next_appointment,
          approved: true
        }
      end
    end
  end
end
