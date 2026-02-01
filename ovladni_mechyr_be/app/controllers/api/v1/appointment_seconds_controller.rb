# frozen_string_literal: true

module Api
  module V1
    class AppointmentSecondsController < AppointmentsController
      # Úkol 11: Override update pro odesílání emailů při změně termínů
      def update
        return if authorize_action(roles: update_permission)
        return if authorize_doctor

        # Uložit staré hodnoty pro porovnání
        old_appointment_date = @form.appointment_date
        is_new_appointment = old_appointment_date.nil?

        if @form.update(form_params)
          # Úkol 11: Poslat email pacientovi
          doctor = current_devise_api_user.doctor
          patient = @form.patient

          if is_new_appointment && @form.appointment_date.present?
            # První nastavení termínu
            UserMailer.second_appointment_scheduled_email(doctor, patient, @form).deliver_later
          elsif !is_new_appointment && @form.appointment_date != old_appointment_date
            # Změna termínu
            UserMailer.second_appointment_updated_email(doctor, patient, @form, old_appointment_date).deliver_later
          end

          render :update, status: :ok
        else
          respond_with_error(@form.errors.full_messages.join(', '), :unprocessable_entity)
        end
      end

      def update_permission
        %i[doctor admin]
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
                                                     :visual_analog_scale,
                                                     :patient_id,
                                                     :notes,
                                                     :multiple_medications,
                                                     :multiple_medications_dosage)
      end
    end
  end
end
