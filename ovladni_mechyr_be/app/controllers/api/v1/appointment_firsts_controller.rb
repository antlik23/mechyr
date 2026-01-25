# frozen_string_literal: true

module Api
  module V1
    class AppointmentFirstsController < AppointmentsController
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
