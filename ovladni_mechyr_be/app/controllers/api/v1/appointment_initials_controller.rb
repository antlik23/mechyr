# frozen_string_literal: true

module Api
  module V1
    class AppointmentInitialsController < AppointmentsController
      def update_permission
        %i[admin]
      end

      def form_params
        params.fetch(:appointment_initial, {}).permit(:assessment_date,
                                                      :diagnosis,
                                                      :alternative_diagnosis,
                                                      :oab_treatment_criteria_met,
                                                      :initiate_pharmacological_treatment,
                                                      :prescribed_medication,
                                                      :dosage,
                                                      :dosage_unit,
                                                      :alternative_dosage_unit,
                                                      :reason_treatment_not_started,
                                                      :alternative_treatment_details,
                                                      :patient_id)
      end
    end
  end
end
