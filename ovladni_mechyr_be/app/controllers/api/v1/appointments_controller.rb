# frozen_string_literal: true

module Api
  module V1
    class AppointmentsController < FormsController
      def create
        return if authorize_action(roles: %i[doctor])

        set_patient_from_user
        return if authorize_doctor

        return render json: { error: I18n.t('errors.messages.duplicate') }.to_json, status: :forbidden unless check_for_previous_form

        @form = form_class.new(form_params)
        set_doctor
        if @form.save
          @message = I18n.t('success.messages.created', resource: form_class.to_s)
          render :create, status: :created
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def form_params
        params.fetch(:appointment_second, {}).permit(:attended_appointment,
                                                     :appointment_date,
                                                     :continuing_treatment,
                                                     :discontinuation_reason,
                                                     :alternative_reason,
                                                     :current_treatment,
                                                     :prescribed_medication,
                                                     :dosage,
                                                     :dosage_unit,
                                                     :alternative_dosage_unit,
                                                     :patient_id)
      end

      def set_doctor
        return if @form.doctor_id.present?

        doctor = current_devise_api_user.doctor
        @form.update(doctor_id: doctor.id) unless doctor.nil?
      end
    end
  end
end
