# frozen_string_literal: true

module Api
  module V1
    class AppointmentFirstsController < AppointmentsController
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
            UserMailer.first_appointment_scheduled_email(doctor, patient, @form).deliver_later
          elsif !is_new_appointment && @form.appointment_date != old_appointment_date
            # Změna termínu
            UserMailer.first_appointment_updated_email(doctor, patient, @form, old_appointment_date).deliver_later
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
        params.fetch(:appointment_first, {}).permit(:appointment_date,
                                                    :consent_signed,
                                                    :meets_project_criteria,
                                                    :clinical_assessment_completed,
                                                    :prolapse_present,
                                                    :stress_test_done,
                                                    :stress_test_result,
                                                    :uti_excluded,
                                                    :bladder_discomfort_vas,
                                                    :diagnosis,
                                                    :alternative_diagnosis,
                                                    :oab_treatment_criteria_met,
                                                    :prescribed_medication,
                                                    :dosage,
                                                    :dosage_unit,
                                                    :alternative_dosage_unit,
                                                    :reason_treatment_not_started,
                                                    :alternative_treatment_details,
                                                    :treatment_contraindications,
                                                    :follow_up_date,
                                                    :patient_id,
                                                    :blood_in_urine,
                                                    :protein_in_urine,
                                                    :sugar_in_urine,
                                                    :post_void_residual_over_100_ml,
                                                    :notes)
      end
    end
  end
end
